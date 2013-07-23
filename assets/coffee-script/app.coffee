# get legendaries
legendaries = []
legendaries.push legendary for key, legendary of window.LegendaryApp.legendaries

# visitor
paths = []
path_map = {}
visit = (node) ->
  node.done = false
  paths.push node.path
  path_map[node.path] = node

# walk nodes for visitors
walk = (node) ->
  visit node
  if node.components?.length
    walk child for child in node.components
  else if node.component?.components?.length
    walk child for child in node.component.components
walk node for node in legendaries

controller = ($scope) ->
  $scope.legendaries = legendaries
  $scope.legendary = legendaries[0]
  $scope.click_handler = ($event) ->
    path = $event.srcElement.parentElement.dataset.path
    node = path_map[path]
    node.done = !node.done
    if node.done
      # mark all children as complete
      regex = new RegExp "^#{node.path}/.+", "i"
      child_paths = paths.filter (p) ->
        regex.test p
      for p in child_paths
        path_map[p].done = true
    else
      # mark all parents as incomplete
      parents = node.path.split '/'
      parents.pop()
      wip = ''
      parents2 = []
      for p in parents
        parent_path = wip + p
        wip = parent_path + '/'
        parents2.push parent_path
      for p in parents2
        path_map[p].done = false

controller.$inject = ['$scope']

angular.module('LegendaryApp', []).controller('TreeController', controller)
