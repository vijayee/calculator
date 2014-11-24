require
  shim:
    jquery:
      exports:'$'
    semantic:
      deps:['jquery']
  paths:
    jquery: '../vendor/jquery/jquery-2.1.1.min'
    angular:'../vendor/angular/angular.min'
    semantic:'../vendor/semantic/semantic.min'
  ['jquery', 'angular','semantic']
  ($, Angular,Semantic)->
    calculatorApp= angular.module('calculatorApp',[])
    calculatorApp.controller 'CalculatorController',['$scope','$http',($scope,$http) ->
      $scope.operations=[]
      $scope.result= "0"
      requestCalculation=->
        data=generateExpression()
        openParan = (data.calculation.match(/\(/g) || []).length
        closeParan = (data.calculation.match(/\(/g) || []).length
        if openParan != closeParan
          return
          scope=$scope
        $http.post('/calculator', data).success (data, status, headers, config) ->
          $scope.result= data.Result
        .error (data, status, headers, config) ->
          $scope.result= data
      generateExpression=->
        expression=""
        for operand in $scope.operations
          expression= expression.concat(operand)
        {calculation:expression}
      accumulateNumber=(num)->
        num=String(num)
        last=$scope.operations.pop()
        if last?
          if $.isNumeric(last)
            if num=="." and String(last).indexOf(".") != -1
              $scope.operations.push(last)
              return
            last=String(last).concat(num)
            $scope.operations.push(last)
            $scope.result=last
          else
            $scope.operations.push(last)
            $scope.operations.push(num)
            $scope.result=num
        else
          $scope.operations.push(num)
          $scope.result=num
      accumulateOperator=(operand)->
        last=$scope.operations.pop()
        if last?
          if $.isNumeric(last)
            $scope.operations.push(last)
            requestCalculation()
            $scope.operations.push(operand)
          else
            $scope.operations.push(last)
            $scope.operations.push(operand) if last== ")"
      negateOperations=->
        last=$scope.operations.pop()
        if $.isNumeric(last)
          if last== $scope.result
            $scope.operations.push("-(")
            $scope.operations.push(last)
            $scope.operations.push(")")
          else
            $scope.operations.push(last)
            $scope.operations.unshift("-(")
            $scope.operations.push(")")
        requestCalculation()
      clear=->
        $scope.operations=[]
        $scope.result= "0"
      undo=->
        remove=$scope.operations.pop()
        last=$scope.operations.pop()
        if $.isNumeric(last)
          $scope.operations.push(last)
          requestCalculation()
        else
          requestCalculation()
          $scope.operations.push(last)
      $scope.operate= (operator)->
        if $.isNumeric(operator) and operator != '-1'
          accumulateNumber(operator)
        else
          switch operator
            when "." then accumulateNumber(operator)
            when "+" then accumulateOperator(operator)
            when "-" then accumulateOperator(operator)
            when "*" then accumulateOperator(operator)
            when "/" then accumulateOperator(operator)
            when "-1" then negateOperations()
            when "=" then requestCalculation()
            when "clear" then clear()
            when "undo" then clear()
        console.log($scope.operations)
    ]
    angular.element(document).ready ->
      angular.bootstrap(document, ['calculatorApp'])
