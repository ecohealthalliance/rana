#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This imports genus names into a mongo collection using the dbpedia sparql endpoint.
There is a query testing interface here: http://dbpedia.org/sparql
"""
import requests
import pymongo
import argparse
import re
import json

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument(
      "--mongo_url", default='localhost:3001'
  )
  parser.add_argument(
      "--db_name", default='meteor'
  )
  args = parser.parse_args()
  db = pymongo.Connection(args.mongo_url)[args.db_name]
  
  print "Importing genera..."
  genera = db['genera']
  genera.drop()
  r = requests.post('http://dbpedia.org/sparql', data={
      'default-graph-uri' : 'http://dbpedia.org',
      'query' : """
      SELECT DISTINCT (str(?genusLabel) as ?g)
      WHERE {
        {
          ?entity dbpprop:genus ?genusLabel .
          ?entity dbpprop:phylum dbpedia:Chordate . 
          FILTER isLiteral(?genusLabel)
        }
        UNION
        {
          ?entity dbpprop:genus ?genus .
          ?entity dbpprop:phylum dbpedia:Chordate .
          ?genus rdfs:label ?genusLabel
        }
      }
      """,
      'format' : 'application/sparql-results+json',
      'timeout' : 60000
    })

  formatPatt = re.compile(ur"""(^['"])|(['"]$)|(\(.*\))|\?""", re.UNICODE)

  def removeStrangeFormatting(s):
    return formatPatt.sub("", s).strip()

  result_set = set([
      removeStrangeFormatting(result['g']['value'])
      for result in r.json()['results']['bindings']
    ])
  for result in result_set:
    # Skip extinct genera
    if u"†" in result: continue
    if len(result) > 0:
      genera.insert({'value':result})

  print "Importing species names..."
  speciesCollection = db['species']
  speciesCollection.drop()
  r = requests.post('http://dbpedia.org/sparql', data={
      'default-graph-uri' : 'http://dbpedia.org',
      'query' : """
      SELECT ?entity
      (group_concat(DISTINCT ?genus;separator=";;") as ?genera)
      (group_concat(DISTINCT ?species;separator=";;") as ?species)
      (group_concat(DISTINCT ?binomial;separator=";;") as ?binomials)
      (group_concat(DISTINCT ?label;separator=";;") as ?labels)
      (group_concat(DISTINCT ?synonym;separator=";;") as ?synonyms)
      WHERE {
        {
          ?entity dbpprop:genus ?genus .
          ?entity dbpprop:species ?species .
          ?entity dbpprop:phylum dbpedia:Chordate .
          OPTIONAL { 
            ?entity dbpprop:binomial ?binomial .
            ?entity rdfs:label ?label .
            ?entity dbpedia-owl:synonym ?synonym
          }
        }
      } GROUP BY ?entity
      """,
      'format' : 'application/sparql-results+json',
      'timeout' : 60000
    })
  # Sometimes there are malformed unicode chars in the response
  resp_text = r.text.replace("\U", "\u")
  for result in json.loads(resp_text)['results']['bindings']:
    genera = result["genera"]["value"].split(";;")
    # If there is more than one genera, it is generall because one is a URI
    # if len(genera) > 1:
    #   print result
    binomials = result["binomials"]["value"].split(";;")
    synonyms = (
      result["species"]["value"].split(";;") +
      binomials +
      result["labels"]["value"].split(";;") +
      result["synonyms"]["value"].split(";;")
    )
    synSet = set([
      removeStrangeFormatting(syn)
      for syn in synonyms
      if len(syn) > 0 
    ])
    speciesCollection.insert({
      "entity": result["entity"]["value"],
      "genera": genera,
      "primaryName": binomials[0],
      "synonyms": list(synSet)
    })
