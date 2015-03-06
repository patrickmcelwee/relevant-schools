xquery version "1.0-ml";
module namespace semanticPubSearch =
  "http://marklogic.com/rest-api/resource/semanticPubSearch";

declare function semanticPubSearch:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  let $output-types :=
    map:put($context,"output-types","application/json") 
  (:return citations, but this time in JSON, with a map that includes IRIs as keys:)
  let $map := map:map()
  let $pubs := map:map()
  let $institutions := map:map()

  let $textQuery := map:get($params, "textQuery")

  let $pubIRIs := 
    sem:triple-subject(
      cts:triples((), sem:iri("http://purl.org/ontology/bibo/abstract"), (), (), (), cts:word-query($textQuery))
    )

  let $build-pubs :=
  for $pubIRI in $pubIRIs return map:put($pubs, $pubIRI, sem:triple-object(
      cts:triples($pubIRI, sem:iri("http://vivo.duke.edu/vivo/ontology/duke-extension#chicagoCitation"), ())
    ))
  let $put-pubs-in-map := map:put($map, "publications", $pubs)

  let $bindings := map:map()
  let $_ := map:put($bindings, "pub", $pubIRIs)
  let $institutions :=
    sem:sparql(
      "SELECT ?label (COUNT(DISTINCT(?author)) AS ?score)
      WHERE {?authorship <http://vivoweb.org/ontology/core#relates> ?pub.
             ?author <http://vivoweb.org/ontology/core#relatedBy> ?authorship.
             ?author <http://purl.obolibrary.org/obo/RO_0000056> ?education.
             ?education <http://purl.obolibrary.org/obo/RO_0002234> ?degree.
             ?degree <http://vivoweb.org/ontology/core#assignedBy> ?institution.
             ?institution <http://www.w3.org/2000/01/rdf-schema#label> ?label.
             } GROUP BY ?label",
      $bindings
    )
  
  let $institutions-in-map := map:put($map, "institutions", $institutions)
  
  return xdmp:to-json($map)
};
