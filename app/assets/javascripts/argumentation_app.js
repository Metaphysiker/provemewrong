var app = angular.module(
    'argumentation',[
    'ngRoute',
    'ngResource',
    'templates',
    'ngAnimate'
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
        });
    }
]);

app.controller("ArgumentationIndexController", [
    '$scope', '$http', '$location', '$sce',
    function($scope, $http, $location, $sce){

        $scope.languageFilter = "a";
        var page = 0;
        $scope.loading = false;
        console.log($scope.loading);
        $scope.highlightterm = "";

        $scope.argumentations = [];
        $scope.search = function(searchTerm) {
            $scope.loading = true;
            $scope.highlightterm = searchTerm;
            if (searchTerm.length < 3) {
                return;
            }
            $http.get("/argumentations.json",
                { "params": { "keywords": searchTerm, "page": page } }
            ).then(
                function(data,status,headers,config) {
                    $scope.argumentations = data.data;
                    $scope.loading = false;
                });
        }

        $scope.viewArgumentation = function(argumentation) {
            $location.path("/" + argumentation.id);
        }

        $scope.previousPage = function() {
            if (page > 0) {
                page = page - 1;
                $scope.search($scope.keywords);
            }
        }
        $scope.nextPage = function() {
            page = page + 1;
            $scope.search($scope.keywords);
        }

        $scope.viewDetails = function(argumentation) {
            $location.path("/" + argumentation.id);
        }

        $scope.highlight = function(haystack, needle) {
            if(!needle) {
                return $sce.trustAsHtml(haystack);
            }
            needle = needle.replace(" ", "|")
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
        $scope.main_argumentation_id = 1;
        $scope.loading = false;
        var argumentationId =  $routeParams.id;
        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        //$scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });

        Argumentation.get({ "argumentationId": argumentationId }).$promise.then(function(argumentation){
            $scope.argumentation = argumentation;
            $scope.argumentcontent = argumentation.arguments[0];
        });

       // $scope.argumentcontent = {"description":"<-- choose Argument", "title": "Argument"};
        $scope.boxClass = 1;

        //all functionss
        function setBoxClass(number){
            $scope.boxClass = number;
        }

        function get_argumentation(boxClass, id){
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
        }



        $scope.nextargumentation = function(boxClass, id) {

            $scope.boxClass = boxClass;

            setTimeout(function() {
                $anchorScroll();
                get_argumentation(boxClass + 1, id);
            }, 1000);
        }


    }
]);
