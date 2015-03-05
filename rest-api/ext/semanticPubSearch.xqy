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

  let $textQuery := map:get($params, "textQuery")

  let $pubIRIs := 
    sem:triple-subject(
      cts:triples((), sem:iri("http://purl.org/ontology/bibo/abstract"), (), (), (), cts:word-query($textQuery))
    )
  let $build-map :=
  for $pubIRI in $pubIRIs return map:put($map, $pubIRI, sem:triple-object(
      cts:triples($pubIRI, sem:iri("http://vivo.duke.edu/vivo/ontology/duke-extension#chicagoCitation"), ())
    ))
  return xdmp:to-json($map)
};
