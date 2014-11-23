@refinder_carpart_demo_module.controller 'HomeController', [
  '$scope', '$http', ($scope, $http) ->
    $scope.criteria =
      text: ""
      selected_groups: []
      qid: 1
    $scope.focusSearch = false
    $scope.search_status = 0
    $scope.hide_tips = false
    $scope.unselect_group = (index) ->
        $scope.criteria.selected_groups.splice(index, 1)
        $scope.do_search()
        $scope.focus_search_input()

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
        $scope.focus_search_input()
        
    $scope.focus_search_input = ->
      $scope.focusSearch = true
      
    $scope.do_send_search_req = ->
      $scope.search_status = 1
      $http.post('/search.json', $scope.criteria)
        .then (server_response) ->
          $scope.update_from_server(server_response.data)
          if $scope.search_status == 1
            $scope.search_status = 0
          else # $scope.search_status == 2
            $scope.do_send_search_req()
              
    $scope.do_search = ->
      if $scope.search_status == 0
        $scope.do_send_search_req()
      else 
        $scope.search_status = 2
      $scope.hide_tips = false
        
      

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
      $scope.hide_tips = false

    $scope.result_info = {groups: []}

    $scope.clear_search = ->
      $scope.hide_tips = true

    $scope.mouse_move_over_button = (sub) ->
      console.log "mouse move over #{sub.name}"

    $scope.input_keypressed = ($event) ->
      console.log $event.keyCode
      switch $event.keyCode
        when 9  then # TAB
        when 13 then # ENTER
        when 8       # BACKSPACE
          if $event.srcElement.selectionStart == 0 and $event.srcElement.selectionEnd == 0
            $scope.criteria.selected_groups.splice(-1, 1)
            $scope.do_search()
        when 37 then # ARROW LEFT
        when 38 then # ARROW UP
        when 39 then # ARROW RIGHT
        when 40 then # ARROW DOWN
        else

    $scope.do_search()
]
