@refinder_carpart_demo_module.controller 'HomeController', [
  '$scope', '$http', ($scope, $http) ->
    $scope.criteria =
      text: ""
      selected_groups: []
    $scope.unselect_group = (index) ->
        $scope.criteria.selected_groups.splice(index, 1)
        $scope.do_search()

    $scope.add_group = (group) ->
        # Once we've selected a group, the set of groups the backend
        # sends us won't have that group included; but until we get a
        # response back, we don't want to allow fast clickers to add
        # the same group multiple times. This means we can do this
        # check by object identity, which keeps things simple, since
        # the id fields in our groups might be of different tables so
        # we don't really want to depend on those.
        unless group in $scope.criteria.selected_groups
            $scope.criteria.selected_groups.push(group)
        $scope.criteria.text = $scope.criteria.text.replace(group.replace, '') if group.replace
        $scope.criteria.selected_groups = _.reject($scope.criteria.selected_groups, (e) ->
            group.replace_box && e.id == group.replace_box.id && e.type == group.replace_box.type)
        $scope.do_search()

    $scope.do_search = ->
      $http.post('/search.json', $scope.criteria)
      .then (server_response) ->
        $scope.update_from_server(server_response.data)

    $scope.update_from_server = (data) ->
        # replace the contents of groups rather than the array itself;
        # this is so that we can use ng-init to assign the reference
        # and let Angular take care of the rest of the data-binding
        # junk
        $scope.result_info.groups.length = 0
        Array.prototype.push.apply($scope.result_info.groups, data.groups)
        $scope.result_info.products = data.products

    $scope.handle_search_criteria_change = ->
        console.log "Text change, now it is #{$scope.criteria.text}"
        $scope.do_search()

    $scope.handle_search_button_click = ->
        console.log "Search button clicked"
        $scope.do_search()

    $scope.input_focus_changed = ($event) ->
      $scope.showtips = not $scope.criteria.criteria_text

    $scope.result_info = {groups: []}

    $scope.do_search()
]
