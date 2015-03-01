(function () {
  'use strict';

  angular.module('sample.detail')
    .controller('DetailCtrl', ['$scope', 'MLRest', '$routeParams', '$sce', function ($scope, mlRest, $routeParams, $sce) {
      var iri = $routeParams.iri;
      var model = {
        // your model stuff here
        detail: {}
      };

      mlRest.getDocument(iri).then(function(response) {
        model.detail =  response.data;
      });

      angular.extend($scope, {
        model: model

      });

      $scope.renderHtml = function(html_code) {
        return $sce.trustAsHtml(html_code);
      };
    }]);
}());
