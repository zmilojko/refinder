@refinder_carpart_demo_module.controller 'HomeController', [
  '$scope', '$http', ($scope, $http) ->
    $scope.criteria =
      text: ""
      selected_groups: []
    $scope.unselect_group = (index) ->
        $scope.criteria.selected_groups.splice(index, 1)
        $scope.do_search()

    $scope.do_search = ->
      $http.post('/search.json', $scope.criteria)
      .then (server_response) ->
        # replace the contents of groups rather than the array itself;
        # this is so that we can use ng-init to assign the reference
        # and let Angular take care of the rest of the data-binding
        # junk
        $scope.result_info.groups.length = 0
        Array.prototype.push.apply($scope.result_info.groups, server_response.data.groups)
        console.log(server_response.data)

    $scope.handle_search_criteria_change = ->
        console.log "Text change, now it is #{$scope.criteria.text}"
        $scope.do_search()

    $scope.handle_search_button_click = ->
        console.log "Search button clicked"
        $scope.do_search()

    $scope.input_focus_changed = ($event) ->
      $scope.showtips = not $scope.criteria.criteria_text
    $scope.add_group = (group) ->
        $scope.criteria.selected_groups.push(group)
        $scope.do_search()

    $scope.result_info = {groups: []}

    $scope.do_search()
]
