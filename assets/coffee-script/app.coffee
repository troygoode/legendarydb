legendaries = []
legendaries.push legendary for key, legendary of window.LegendaryApp.legendaries

controller = ($scope) ->
  $scope.legendaries = legendaries
  $scope.legendary = legendaries[0]
controller.$inject = ['$scope']

angular.module('LegendaryApp', []).controller('TreeController', controller)
