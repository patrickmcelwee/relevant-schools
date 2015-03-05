(function () {
  'use strict';

  angular.module('sample.search')
    .controller('SearchCtrl', ['$scope', 'MLRest', 'User', '$location', '$sce', function ($scope, mlRest, user, $location, $sce) {
      var model = {
        selected: [],
        text: '',
        user: user
      };

      function updateSearchResults(data) {
        model.search = data;
      }

      angular.extend($scope, {
        model: model,
        textSearch: function() {
          mlRest.callExtension('semanticPubSearch',
            { 'method': 'GET', 'params': {'rs:textQuery': model.text} }
            ).then(updateSearchResults);
          $location.path('/');
        }
      });

    $scope.renderHtml = function(html_code) {
      return $sce.trustAsHtml(html_code);
    };

    }]);
}());
