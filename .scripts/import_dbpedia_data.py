"""
This imports genus names into a mongo collection using the dbpedia sparql endpoint.
There is a query testing interface here: http://dbpedia.org/sparql
"""
import requests
import pymongo
import argparse
import re

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument(
      "--mongo_url", default='localhost'
  )
  parser.add_argument(
      "--db_name", default='local'
  )
  args = parser.parse_args()
  db = pymongo.Connection(args.mongo_url)[args.db_name]
  collection = db['genera']
  collection.drop()
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
  def removeStrangeFormatting(s):
    return re.sub("""(^['"])|(['"]$)||(\(.*\))""", "", s)
    
  result_set = set([
      removeStrangeFormatting(result['g']['value'])
      for result in r.json()['results']['bindings']
    ])
  for result in result_set:
    collection.insert({'value':result})
