$(document).on('ready page:load', function() {
	angular.bootstrap('body', ['ngHandsontableDemo'])
});

angular.module('ngHandsontableDemo',
	[
		'ngHandsontable'
	])
	.controller(
		'DemoCtrl', [
			'$scope',
			function ($scope) {

				var firstNames = ["Ted", "John", "Macy", "Rob", "Gwen", "Fiona", "Mario", "Ben", "Kate", "Kevin", "Thomas", "Frank"];
				var titles = ["Intern", "Manager", "Associate", "Account Executive", "Supervisor", "Vice President", "Specialist", "Commander", "Admiral", "Private", "Master Sergeant", "Loremaster"];
				var departments = ["Sales", "Finance", "HR", "Marketing", "R&D", "IT", "Admin", "Fitness", "Food Services", "Custodial", "Fashion", "Rest 'n Vest"];

				$scope.minSpareRows = 0;
				$scope.minSpareCols = 0;
				$scope.colHeaders = true;

				$scope.db = {};
				$scope.db.items = [];

				$scope.colIdx = 0;
				$scope.rowIdx = 0;

				$scope.swap = function(id)
				{
					$scope.db.items = [];

					switch (id)
					{
						case 404:
						$scope.db.items = [
				          ['Name', 'Job Title', 'Department', 'Base Salary'],
				          ['John', 'Manager', 'Sales', 80000],
				          ['Justin', 'Associate', 'Sales', 70000],
				          ['Nick', 'Intern', 'Sales', 60000]
				        ];
				        break;

						case 405:
						$scope.db.items = [
				          ['Name', 'Job Title', 'Department', 'Base Salary','Projected Salary'],
				          ['John', 'Manager', 'Sales', 80000],
				          ['Justin', 'Associate', 'Sales', 70000],
				          ['Nick', 'Intern', 'Sales', 60000]
				        ];
				        break;

				        case 406:
						$scope.db.items = [
				          ['Name', 'Job Title', 'Department', 'Base Salary','Projected Salary','Cost'],
				          ['John', 'Manager', 'Sales', 80000, '=D2*1.03'],
				          ['Justin', 'Associate', 'Sales', 70000, '=D3*1.03'],
				          ['Nick', 'Intern', 'Sales', 60000, '=D4*1.03'],
				          ['', '', '', '', '','(total cost)']
				        ];
				        break;

				        case 407:
						$scope.db.items = [
				          ['Name', 'Job Title', 'Department', 'Base Salary','Projected Salary','Cost'],
				          ['John', 'Manager', 'Sales', 80000, '=D2*1.03', '=E2-D2'],
				          ['Justin', 'Associate', 'Sales', 70000, '=D3*1.03','=E3-D3'],
				          ['Nick', 'Intern', 'Sales', 60000, '=D4*1.03','=E4-D4'],
				          ['', '', '', '', '','=SUM(F2:F4)']
				        ];
				        break;

				        case 408:
				        console.log('swapping')
				        $scope.db.items.push(['Name', 'Job Title', 'Department', 'Base Salary','Projected Salary','Cost','Total Cost','Salary Increase %']);
						for (var i = 0; i < 1000; i++)
						{
							var rowIdx = i + 2;
							$scope.db.items.push(
								[
								firstNames[Math.floor(Math.random() * firstNames.length)],
								titles[Math.floor(Math.random() * titles.length)],
								departments[Math.floor(Math.random() * departments.length)],
								Math.round(Math.floor(Math.random()*60000 + 40000) / 10) * 10,
								'',
								'=E' + rowIdx + '-D' + rowIdx
								]
							);
						}
						$scope.db.items[1][6] = 0;
						$scope.db.items[1][7] = 0;
						break;

						case 409:
						$scope.db.outputs = [];
						$scope.db.inputs = [];
				        $scope.db.outputs.push(['Name', 'Job Title', 'Department', 'Base Salary','Projected Salary','Cost','Total Cost']);
						for (var i = 0; i < 100; i++)
						{
							var rowIdx = i + 2;
							$scope.db.outputs.push(
								[
								firstNames[Math.floor(Math.random() * firstNames.length)],
								titles[Math.floor(Math.random() * titles.length)],
								departments[Math.floor(Math.random() * departments.length)],
								Math.round(Math.floor(Math.random()*60000 + 40000) / 10) * 10,
								'=D' + rowIdx + '*H2',
								'=E' + rowIdx + '-D' + rowIdx
								]
							);
						}
						$scope.db.outputs[1][6] = '=SUM(F2:F1001)';
						$scope.db.outputs[1][7] = '1.05';
						$scope.db.items = $scope.db.outputs;
				        $scope.db.inputs = [
				          ['Salary Increase %'],
				          ['(salary % input)']
				        ];
				        break;
					}
				}

				$scope.edit = function(x,y) { $scope.colIdx = x; $scope.rowIdx = y; }

				$scope.checkWork = function(id)
				{
					console.log('checking work',id);
					var items = $scope.db.items;
					for (var i=0;i<items.length;i++)
					{
						var item = items[i];
						for (var j=0;j<item.length;j++)
						{
							if (item[j])
							{
								// console.log(item[j]);
								//trims everything, which will look a little off after you hit submit work
								var str = item[j].toString().replace(/ /g, '');
								item[j] = str;
							}
						}
					}

					var pass = false;

					switch (id)
					{
						case 404:
							if($scope.db.items[1][3] == '=80000*1.03' && $scope.db.items[2][3] == '=70000*1.03' && $scope.db.items[3][3] == '=60000*1.03')
							{
								pass = true;
							}
							break;
						case 405:
							if($scope.db.items[1][4] == '=D2*1.03' && $scope.db.items[2][4] == '=D3*1.03' && $scope.db.items[3][4] == '=D4*1.03')
							{
								pass = true;
							}
							break;
						case 406:
							if($scope.db.items[1][5] == '=E2-D2' && $scope.db.items[2][5] == '=E3-D3' && $scope.db.items[3][5] == '=E4-D4' && $scope.db.items[4][5] == '=SUM(F2:F4)')
							{
								pass = true;
							}
							break;
						case 407:
							if($scope.db.items[1][4] == '=D2*1.05' && $scope.db.items[2][4] == '=D3*1.05' && $scope.db.items[3][4] == '=D4*1.05')
							{
								pass = true;
							}
							break;
						case 408:
							if($scope.db.items[1][4] == '=D2*$H2' && $scope.db.items[1][7] == '1.05' && $scope.db.items[1][6] == '=SUM(F2:F1001)')
							{
								pass = true;
							}
							break;
						case 409:
							pass = true;
							break;
					}
					if (pass)
					{
						$('#submit-work').hide();
						$('#reset-sheet').hide();
						$('#error-bar').hide();
						$('#success-bar').fadeIn(1000);
						$.ajax({
						    url : '/modules', //Target URL for JSON file
						    //contentType: 'application/json',
						    method: 'POST',
						    data: {'module_id':1},
						    success : function(data){
						        console.log(data);
						    },
						    error : function(xhr, status){
						        console.log(status);
						    }
						});
					}else{
						$('#error-bar').hide();
						$('#error-bar').fadeIn(1000);
					}
				}
			}
		]
	);