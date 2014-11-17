@refinder_carpart_demo_module.controller 'HomeController', [
  '$scope', ($scope) ->
    $scope.showtips = false
    $scope.criteria =
      criteria_text: null
    $scope.handle_search_criteria_change = ->
      console.log "Text change, now it is #{$scope.criteria.criteria_text}"
    $scope.handle_search_button_click = ->
      console.log "Search button clicked"
    $scope.input_focus_changed = ($event) ->
      $scope.showtips = not $scope.criteria.criteria_text
]