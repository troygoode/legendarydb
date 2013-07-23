_ = require 'underscore'
data = require('require-directory')(module)

# provide an 'id' to each node corresponding to the filename minus ext
legendary.id = key for key, legendary of data.legendaries
component.id = key for key, component of data.components

# build a tree
for key, legendary of data.legendaries
  if legendary.components?
    arr = []
    for subcomponent_key, quantity of legendary.components
      arr.push component: data.components[subcomponent_key], quantity: quantity
    legendary.components = arr
for key, component of data.components
  if component.components?
    arr = []
    for subcomponent_key, quantity of component.components
      arr.push component: data.components[subcomponent_key], quantity: quantity
    component.components = arr

# specify a full-qualified path to each node
map_path = (parent) ->
  (c) ->
    c2 =
      quantity: c.quantity
      component: _.clone c.component
    if parent?
      c2.path = "#{parent.path}/#{c.component.id}"
    else
      c2.path = c.component.id
    c2.component.components = c2.component.components.map(map_path(c2)) if c2.component.components?
    c2
for key, l of data.legendaries
  l.path = l.id
  if l.components?
    l.components = l.components.map map_path(path: key)

module.exports = data
