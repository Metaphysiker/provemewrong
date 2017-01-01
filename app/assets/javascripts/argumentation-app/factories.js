app = angular.module(
    'argumentationcontroller');


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

app.factory('CreateAndRedirectArgumentation', ['$resource', '$location', function($resource, $location) {
    return{
        createArgumentation: function() {
            var newArgumentation = $resource('/argumentations.json', null,
                {
                    'create': { method:'POST' }
                });
            newArgumentation.create(function(response){
                $location.path("/edit/" + response.id)
            });
        }
    }
}]);

app.factory('DeleteFullArgumentation', ['$resource', '$location', '$http', function($resource, $location, $http) {
    return{
        DeletingFullArgumentation: function(argumentation_id) {
           return $http({
                method: 'POST',
                url: '/deletefullargumentation/' + argumentation_id
            });
        }
    }
}]);


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




app.factory('argumentationMainMethods', ['$resource', '$http','$timeout', 'argumentationResource', '$anchorScroll', '$location', function($resource, $http,$timeout, argumentationResource, $anchorScroll, $location) {
    return{
        getlastargument: function(argumentation){
            var lastargument;
            for (var i = 0; i < argumentation.arguments.length; i++) {
                if(argumentation.arguments[i].place ==argumentation.arguments.length ) {
                    lastargument = argumentation.arguments[i];
                }
            }
            return lastargument;
        },
        start: function(scope, argumentationId,startingposition) {

            if(/edit/.test($location.$$path)){
                scope.environment = "edit";
            } else {
                scope.environment = "show";
            }

            function getfirstargument(argumentation){
                var firstargument;
                for (var i = 0; i < argumentation.arguments.length; i++) {
                    if(argumentation.arguments[i].place == 1) {
                        firstargument = argumentation.arguments[i];
                    }
                }
                return firstargument;
            }

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
                scope.argumentcontent = getfirstargument(argumentation);
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

            scope.to_the_overview = function(){
                $location.path("/overview");
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