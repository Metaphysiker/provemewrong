var app = angular.module(
    'argumentation',[
    'ngRoute',
    'ngResource',
    'templates',
    'ngAnimate',
    'ngMessages'
]);

app.config([
    "$routeProvider",
    function($routeProvider) {
        $routeProvider.when("/:id", {
            controller: "ArgumentationShowController",
            templateUrl: "argumentation_show.html"
        }).when("/",{
            controller: "ArgumentationIndexController",
            templateUrl: "argumentation_index.html"
        }).when("/edit/:id", {
            controller: "ArgumentationEditController",
            templateUrl: "argumentation_edit.html"
        });
    }
]);


app.controller("ArgumentationEditController",[
    '$scope', '$routeParams', '$resource', '$http', function($scope, $routeParams, $resource,  $http){
        var argumentationId =  $routeParams.id;
        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        var newArgumentation = $resource('/argumentations.json/',{}, {'save':   {'method':'POST'}});
        $scope.selectedArguments = [];

        if (argumentationId == 0){
           newArgumentation.save().$promise.then(function(argumentation){
               $scope.argumentation = argumentation;
                argumentationId = argumentation.id;
           });
        } else {
            Argumentation.get({ "argumentationId": argumentationId }).$promise.then(function(argumentation){
                $scope.argumentation = argumentation;
                $scope.argumentcontent = argumentation.arguments[0];
            });
        }

        $scope.getcontent = function(argument){
            $scope.argumentcontent = argument;
        };

        $scope.save = function() {
            if ($scope.form.$valid) {
                $http.put("/argumentations/" + argumentationId + ".json",
                    { "params": $scope.argumentation }
                ).then(
                    function(data,status,headers,config) {
                        alert('Saved!')
                        $scope.form.$setPristine();
                        $scope.form.$setUntouched();
                    });
            }


        };


        $scope.switcharguments = function (){

            //first_argument = $scope.argumentation.arguments[0]
            //second_argument = $scope.argumentation.arguments[1]

            var first_argument = $scope.selectedArguments[0];
            var second_argument = $scope.selectedArguments[1];

            var first_place = first_argument.place;
            var second_place = second_argument.place;

            first_argument.place = second_place;
            second_argument.place = first_place;

            $scope.selectedArguments = [];

            $scope.form.$setDirty();
            $scope.form.$setTouched();

           // $scope.argumentation.arguments[second_argument].place = first_argument;
        }


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

app.controller("ArgumentationIndexController", [
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
            ).then(
                function(data,status,headers,config) {
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

        $scope.viewDetails = function(argumentation) {
            $location.path("/" + argumentation.id);
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



app.controller("ArgumentationShowController", [
    '$scope', '$resource', '$q','$timeout', '$anchorScroll', '$routeParams',
    function($scope, $resource, $q, $timeout, $anchorScroll, $routeParams) {

        // all vars and assignments
       // $scope.main_argumentation_id = 1;
        $scope.loading = false;
        var argumentationId =  $routeParams.id;
        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        var ParentArgumentation = $resource('/getparentargumentation/:argumentId.json', {"argumentId": "@argument_id"});
        $scope.boxClass = 1;
        //$scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });
        Argumentation.get({ "argumentationId": argumentationId }).$promise.then(function(argumentation){
            $scope.argumentation = argumentation;
            $scope.argumentcontent = argumentation.arguments[0];
        });

       // $scope.argumentcontent = {"description":"<-- choose Argument", "title": "Argument"};

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
                $scope.argumentcontent = argumentation.arguments[0];

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
