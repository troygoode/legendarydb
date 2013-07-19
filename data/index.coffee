data = require('require-directory')(module)

legendary.id = key for key, legendary of data.legendaries
component.id = key for key, component of data.components

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

module.exports = data
