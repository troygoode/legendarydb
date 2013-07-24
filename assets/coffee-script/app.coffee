# store
if window.localStorage
  value = window.localStorage.getItem('LegendaryApp-Progress') ? ''
  split = value.split ','
  store = {}
  for p in split
    if p?.length
      store[p] = true
  selected_legendary_id = window.localStorage.getItem('LegendaryApp-SelectedLegendary')
else
  store = {}
  selected_legendary_id = null

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

persist = ->
  value = []
  value.push key for key of store
  value = value.join(',')
  window.localStorage.setItem 'LegendaryApp-Progress', value

toggle = (node, value) ->
  node.done = value
  if node.done
    store[node.path] = true
  else if store[node.path]?
    delete store[node.path]
  if window.localStorage
    persist()

for key of store
  toggle path_map[key], true

find_parent_with_dataset = (el, key) ->
  if el.dataset[key]?
    el
  else if el.parentElement?
    find_parent_with_dataset el.parentElement, key
  else
    null

controller = ($scope) ->
  $scope.legendaries = legendaries
  if selected_legendary_id?
    $scope.legendary = legendaries.filter((l) -> l.id is selected_legendary_id)[0]
  else
    $scope.legendary = legendaries[0]
  $scope.$watch 'legendary', (new_value, old_value) ->
    if window.localStorage
      window.localStorage.setItem 'LegendaryApp-SelectedLegendary', new_value.id
  $scope.click_handler = ($event) ->
    path = find_parent_with_dataset($event.srcElement, 'path').dataset.path
    node = path_map[path]
    toggle node, !node.done
    if node.done
      # mark all children as complete
      regex = new RegExp "^#{node.path}/.+", "i"
      child_paths = paths.filter (p) ->
        regex.test p
      for p in child_paths
        toggle path_map[p], true
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
        toggle path_map[p], false

controller.$inject = ['$scope']

angular.module('LegendaryApp', []).controller('TreeController', controller)
