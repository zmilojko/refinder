@refinder_carpart_demo_module.directive 'searchItem', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        element[0].classList.add('search-item-' + (scope.item.type || 'untyped'))

