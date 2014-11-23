@refinder_carpart_demo_module.directive 'searchInput', ($timeout) ->
    ret =
      restrict: 'A'
      link: (scope, element, attrs) ->
        scope.$watch attrs.searchInput, ->
          if scope.focusSearch
            $timeout ->
              element[0].focus()
          scope.focusSearch = false
