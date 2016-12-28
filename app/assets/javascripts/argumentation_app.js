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

app.factory('argumentationMethods',['$resource', function($resource) {
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
        }
    };
}]);

app.factory('argumentationResource', ['$resource', function($resource) {
    return $resource('/argumentations/:argumentationId.json', null,
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


app.controller("ArgumentationEditController",[
    '$scope', '$routeParams', '$resource', '$http', 'argumentationMethods', 'argumentationResource', 'newArgumentationResource', function($scope, $routeParams, $resource,  $http, argumentationMethods, argumentationResource, newArgumentationResource){

        $scope.switchmode = false;
        $scope.deletemode = false;
        var argumentationId =  $routeParams.id;
        //var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        //var newArgumentation = $resource('/argumentations.json/',{}, {'save':   {'method':'POST'}});
        $scope.selectedArguments = [];

        if (argumentationId == 0){
           newArgumentationResource.create().$promise.then(function(argumentation){
               $scope.argumentation = argumentation;
                argumentationId = argumentation.id;
               $scope.argumentcontent = argumentationMethods.getfirstargument(argumentation);
           });
        } else {
            argumentationResource.get({ "argumentationId": argumentationId }).$promise.then(function(argumentation){
                $scope.argumentation = argumentation;
                $scope.argumentcontent = argumentationMethods.getfirstargument(argumentation);
            });
        }

        $scope.addArgument = function(){
            if(!$scope.form.$pristine) {
                swal("In order to add an argument, you need to save first.");
            } else {
                swal("Argument added!", "", "success");
            }
        };

        $scope.destroyArgument = function(){
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
                        swal("Deleted!", "Your imaginary file has been deleted.", "success");
                    });
            }
        };

        $scope.getcontent = function(argument){
            $scope.argumentcontent = argument;
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
    '$scope', '$resource', '$q','$timeout', '$anchorScroll', '$routeParams', 'argumentationMethods',
    function($scope, $resource, $q, $timeout, $anchorScroll, $routeParams, argumentationMethods) {

        $scope.loading = false;
        var argumentationId =  $routeParams.id;
        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        var ParentArgumentation = $resource('/getparentargumentation/:argumentId.json', {"argumentId": "@argument_id"});
        $scope.boxClass = 1;

        Argumentation.get({ "argumentationId": argumentationId }).$promise.then(function(argumentation){
            $scope.argumentation = argumentation;
            $scope.argumentcontent = argumentationMethods.getfirstargument(argumentation);
        });


        //main-function
        $scope.get_argumentation = function(type,id,boxClass, argumentcontent){
            type = type || 'argumentation';
            id = id || 0;
            boxClass = boxClass || 2;
            argumentcontent = argumentcontent || 0;


            setBoxClass(boxClass);

            setTimeout(function() {
                $anchorScroll();
                toggleLoading();


                if (type == 'argumentation'){

                    Argumentation.get({ "argumentationId": id }).$promise.then(function(argumentation) {
                        $scope.argumentation = argumentation;
                        toggleLoading();
                        $scope.argumentcontent = argumentation.arguments[argumentcontent];
                        $timeout(function() {
                            setBoxClass(boxClass + 1);
                        }, 1000);

                    }, function(reason) {
                        alert('Failed: ' + reason);
                    });

                } else if (type == 'argument'){

                    ParentArgumentation.get({ "argumentId": id }).$promise.then(function(argumentation){
                        $scope.argumentation = argumentation;
                        toggleLoading();
                        $scope.argumentcontent = argumentation.arguments[argumentcontent];
                        $timeout(function() {
                            setBoxClass(boxClass + 1);
                        }, 1000);
                    }, function(reason) {
                        alert('Failed: ' + reason);
                    });
                }

            }, 1000);


        };

        //all functionss
        function setBoxClass(number){
            $scope.boxClass = number;
        }

        function toggleLoading(){
            if ($scope.loading == true){
                $scope.loading = false;
            } else {
                $scope.loading = true;
            }
        }

        function get_argumentation1(boxClass, id){
            $scope.loading = true;

            Argumentation.get({ "argumentationId": id }).$promise.then(function(argumentation) {
                $scope.argumentation = argumentation;
                $scope.loading = false;
                getfirstargument(argumentation);

                $timeout(function() {
                    setBoxClass(boxClass);
                }, 1000);

            }, function(reason) {
                alert('Failed: ' + reason);
            });

        }

        $scope.getcontent = function(argument){
            $scope.argumentcontent = argument;
        };



        $scope.nextargumentation = function(boxClass, id) {

            $scope.boxClass = boxClass;

            setTimeout(function() {
                $anchorScroll();
                get_argumentation(boxClass + 1, id);
            }, 1000);
        }

        $scope.backtoparentargumentation = function(boxClass, argument_id){
            $scope.boxClass = boxClass;

            var argumentationId = 0;

            Argumentation.get({ "argumentId": argument_id }).$promise.then(function(argumentation_id) {
                argumentationId = argumentation_id;

            }, function(reason) {
                alert('Failed: ' + reason);
            });

        }


    }
]);


app.controller("ArgumentationSearchController", [
    '$scope', '$http', '$location', '$sce',
    function($scope, $http, $location, $sce){


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
            $location.path("/" + argumentation.id);
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