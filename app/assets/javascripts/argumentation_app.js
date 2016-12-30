var app = angular.module(
    'argumentation',[
    'ngRoute',
    'ngResource',
    'templates',
    'ngAnimate',
    'ngMessages',
    'ng-sweet-alert'
]);

app.config([
    "$routeProvider",
    function($routeProvider) {
        $routeProvider.when("/search",{
            controller: "ArgumentationSearchController",
            templateUrl: "argumentation_search.html"
        }).when("/edit/:id", {
            controller: "ArgumentationEditController",
            templateUrl: "argumentation_edit.html"
        }).when("/:id", {
            controller: "ArgumentationShowController",
            templateUrl: "argumentation_show.html"
        });
    }
]);

app.factory('argumentationMethods',['$resource','$location', 'parentArgumentationResource', function($resource, $location, parentArgumentationResource) {
    return {
        foo: function() {
            alert("I'm foo!");
        },
        getfirstargument: function(argumentation){
            var firstargument;
            for (var i = 0; i < argumentation.arguments.length; i++) {
                if(argumentation.arguments[i].place == 1) {
                    firstargument = argumentation.arguments[i];
                }
            }
            return firstargument;
        },
        get_argumentation: function(argumentation_id, startingposition, edit){
            startingposition = startingposition || 1;
            edit = edit || false;

            if (edit == true){
                $location.path("/edit/" + argumentation_id).search({"sp": startingposition});
            } else {
                $location.path("/" + argumentation_id).search({"sp": startingposition});
            }


        },
        get_parent_argumentation: function(argument_id, startingposition, edit){
            startingposition = startingposition || 1;
            edit = edit || false;
            parentArgumentationResource.get({ "argumentId": argument_id }).$promise.then(function(argumentation){

                if (edit = true){
                    $location.path("/edit/" + argumentation.id).search({"sp": startingposition});
                } else {
                    $location.path("/" + argumentation.id).search({"sp": startingposition});
                }
            });

        }
    };
}]);


app.factory('argumentationResource', ['$resource', function($resource) {
    return $resource('/argumentations/:argumentationId.json', null,
        {
            'update': { method:'PUT' }
        });
}]);

app.factory('parentArgumentationResource', ['$resource', function($resource) {
    return $resource('/getparentargumentation/:argumentId.json', null,
        {
            'update': { method:'PUT' }
        });
}]);

app.factory('newArgumentationResource', ['$resource', function($resource) {
    return $resource('/argumentations.json', null,
        {
            'create': { method:'POST' }
        });
}]);

app.factory('argumentationMainMethods', ['$resource', '$http','$timeout', 'argumentationResource', '$anchorScroll', '$location', function($resource, $http,$timeout, argumentationResource, $anchorScroll, $location) {
    return{
        start: function(scope, argumentationId,startingposition) {

            $http.get("/get_current_user.json").then(function(data,status,headers,config) {
                scope.userid = data.data;
            });

            scope.loading = false;

            if(startingposition != undefined){
                scope.boxClass = startingposition;
            } else {
                scope.boxClass = 1;
            }

            argumentationResource.get({ "argumentationId": argumentationId }).$promise.then(function(argumentation){
                scope.argumentation = argumentation;
                scope.argumentcontent = argumentation.arguments[0];
                $timeout(function() {
                    scope.boxClass = 1;
                }, 1000);
            });

            scope.get_next_argumentation = function(argumentation_id,startingposition, edit){
                scope.boxClass = scope.boxClass + 3;
                $timeout(function() {
                    $anchorScroll();

                    startingposition = startingposition || 1;
                    edit = edit || false;

                    if (edit == true){
                        $location.path("/edit/" + argumentation_id).search({"sp": startingposition});
                    } else {
                        $location.path("/" + argumentation_id).search({"sp": startingposition});
                    }

                }, 1000);

            };

            scope.get_parent_argumentation = function(argument_id,startingposition, edit){
                scope.boxClass = scope.boxClass + 1;
                $timeout(function() {
                    $anchorScroll();

                    startingposition = startingposition || 1;
                    edit = edit || false;


                    var parentArgumentation = $resource('/getparentargumentation/:argumentId.json', {"argumentId": "@argument_id"},{'post': { method:'POST' }});
                    parentArgumentation.get({ "argumentId": argument_id }).$promise.then(function(argumentation){

                        if (edit == true){
                            $location.path("/edit/" + argumentation.id).search({"sp": startingposition});
                        } else {
                            $location.path("/" + argumentation.id).search({"sp": startingposition});
                        }
                    });

                }, 1000);
            };

            scope.getcontent = function(argument){
                scope.argumentcontent = argument;
            };

        }

    }
}]);


app.controller("ArgumentationEditController",[
    '$scope', '$routeParams', '$resource', '$http', 'argumentationMethods', 'argumentationResource', 'newArgumentationResource','$timeout', '$anchorScroll', 'argumentationMainMethods', function($scope, $routeParams, $resource,  $http, argumentationMethods, argumentationResource, newArgumentationResource, $timeout, $anchorScroll, argumentationMainMethods){

        var argumentationId =  $routeParams.id;
        var startingposition = $routeParams.sp;

        argumentationMainMethods.start($scope, argumentationId, startingposition);

        $scope.switchmode = false;
        $scope.deletemode = false;
        $scope.selectedArguments = [];
        $scope.selectedArgumentToDestroy;

        $scope.addArgument = function(){
            var addArgumentto = $resource('/addargumenttoargumentation/:argumentationId.json', {"argumentationId": argumentationId}, {'create': { method:'POST' }});
            if(!$scope.form.$pristine) {
                swal("In order to add an argument, you need to save first.");
            } else {
                addArgumentto.create().$promise.then(function(argumentation){
                    $scope.argumentation = argumentation;
                    $scope.argumentcontent = argumentationMethods.getfirstargument(argumentation);
                    swal("Argument added!", "", "success");
                });
            }
        };

        $scope.destroyArgument = function(){
            var place = $scope.selectedArgumentToDestroy.place;
            var deleteArgumentfrom = $resource('/deleteargumenttoargumentation/:argumentationId.json', {"argumentationId": argumentationId, "place": place}, {'post': { method:'POST' }});
            if(!$scope.form.$pristine) {
                swal("In order to delete an argument, you need to save first.");
            } else {
                swal({
                        title: "Are you sure?",
                        text: "You will not be able to recover this argument!",
                        type: "warning",
                        showCancelButton: true,
                        confirmButtonColor: "#DD6B55",
                        confirmButtonText: "Yes, delete it!",
                        closeOnConfirm: false
                    },
                    function(){
                        deleteArgumentfrom.post().$promise.then(function(argumentation){
                            $scope.argumentation = argumentation;
                            $scope.argumentcontent = argumentationMethods.getfirstargument(argumentation);
                            swal("Deleted!", "Argument has been removed.", "success");
                        });
                    });
            }
        };

        $scope.toggleSelectionForDeletion = function(argument){
            $scope.selectedArgumentToDestroy = argument;
            console.log($scope.selectedArgumentToDestroy);
        };

        $scope.toggleDeleteMode = function(){
            $scope.switchmode = false;
            if($scope.deletemode == false){
                $scope.deletemode = true;
            } else {
                $scope.deletemode = false;
            }
        };

        $scope.toggleSwitchMode = function(){
            $scope.deletemode = false;
            if($scope.switchmode == false){
                $scope.switchmode = true;
            } else {
                $scope.switchmode = false;
            }
        };


        $scope.save = function() {
            if ($scope.form.$valid) {
                console.log($scope.argumentation);
                argumentationResource.update({ "argumentationId": argumentationId },$scope.argumentation).$promise.then(function(){
                    swal("Saved!", "", "success");
                    $scope.form.$setPristine();
                    $scope.form.$setUntouched();
                });
            }
        };


        $scope.switcharguments = function (){

            var first_argument = $scope.selectedArguments[0];
            var second_argument = $scope.selectedArguments[1];

            var first_place = first_argument.place;
            var second_place = second_argument.place;

            first_argument.place = second_place;
            second_argument.place = first_place;

            $scope.selectedArguments = [];

            $scope.form.$setDirty();
        };

        $scope.toggleSelection = function(argument){
            var idx = $scope.selectedArguments.indexOf(argument);

            // is currently selected
            if (idx > -1) {
                $scope.selectedArguments.splice(idx, 1);
            }

            // is newly selected
            else {
                if($scope.selectedArguments.length > 1){
                    $scope.selectedArguments.splice(0, 1);
                    $scope.selectedArguments.push(argument);
                } else {
                    $scope.selectedArguments.push(argument);
                }
            }
        }

    }
]);

app.controller("ArgumentationShowController", [
    '$scope', '$resource', '$q','$timeout', '$anchorScroll', '$routeParams', 'argumentationMethods', 'argumentationResource', 'parentArgumentationResource', 'argumentationMainMethods',
    function($scope, $resource, $q, $timeout, $anchorScroll, $routeParams, argumentationMethods, argumentationResource, parentArgumentationResource, argumentationMainMethods) {

        var argumentationId =  $routeParams.id;
        var startingposition = $routeParams.sp;

        argumentationMainMethods.start($scope, argumentationId, startingposition);

    }
]);


app.controller("ArgumentationSearchController", [
    '$scope', '$http', '$location', '$sce','argumentationMethods',
    function($scope, $http, $location, $sce, argumentationMethods){


        $scope.search = function(searchTerm) {
            $scope.loading = true;
            $scope.highlightterm = searchTerm;

            if (searchTerm.length < 3) {
                return;
            }
            $http.get("/argumentations.json",
                        { "params": { "keywords": searchTerm, "page": $scope.page } }
                    ).then(function(data,status,headers,config) {
                        $scope.argumentations = data.data;
                        $scope.loading = false;
                    });
            };

        $scope.loading = false;
        $scope.page = 0;
        $scope.highlightterm = "";
        $scope.argumentations = [];
        var div = document.getElementById('div-item-data');
        $scope.keywords = div.getAttribute("data-item-name");

        if ($scope.keywords.length >= 3){
            $scope.search($scope.keywords);
        }

        $scope.viewArgumentation = function(argumentation) {
            //$location.path("/" + argumentation.id);
            argumentationMethods.get_argumentation(argumentation.id,1,false);
        };

        $scope.previousPage = function() {
            if ($scope.page > 0) {
                $scope.page = $scope.page - 1;
                $scope.search($scope.keywords);
            }
        };
        $scope.nextPage = function() {
            $scope.page = $scope.page + 1;
            $scope.search($scope.keywords);
        };

        $scope.highlight = function(haystack, needle) {
            if(!needle) {
                return $sce.trustAsHtml(haystack);
            }
            needle = needle.replace(/\s/g, "|");
            return $sce.trustAsHtml(haystack.replace(new RegExp(needle, "gi"), function(match) {
                return '<span class="highlightedText">' + match + '</span>';
            }));
        };

    }
]);