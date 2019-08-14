				var area=d3.select("body")
							.select("#circle_area")
							.append("svg")
							.attr("width",600)
							.attr("height",600);
				var count=0;
				var center_x=300;
				var center_y=230;
				var color1=d3.rgb(0,120,215);
				var color2=d3.rgb(0,193,215);
				var inner_circle_r=110;
				var upper_circle_r=120;
				var inner_circle=area.append("circle")
									.attr("cx",center_x)
									.attr("cy",center_y)
									.attr("r",inner_circle_r)
									.attr("stroke",color1)
									.attr("stroke-width",5)
									.attr("stroke-opacity",.6)
									.attr("fill-opacity",.0)
									.attr("fill","black");

				var upper_circle=area.append("circle")
									.attr("cx",center_x)
									.attr("cy",center_y)
									.attr("r",upper_circle_r)
									.attr("stroke",color1)
									.attr("stroke-width",3)
									.attr("stroke-opacity",.6)
									.attr("fill-opacity",.0)
									.attr("fill","black");

				var light=area.append("circle")
								.attr("cx",center_x)
								.attr("cy",center_y)
								.attr("r",100)
								.attr("fill",color1);

				//var interval_time;
				/*function make_inner_invisible()
				{
					setInterval(function(){
						//console.log(interval_time);
					inner_circle.attr("stroke-opacity",.6)
								.transition()
								.duration(parseInt(interval_time))
								.attr("stroke-opacity",.0)
								.transition()
								.duration(parseInt(interval_time))
								.attr("stroke-opacity",.6);
					upper_circle.attr("r",upper_circle_r)
								.transition()
								.duration(parseInt(interval_time))
								.attr("r",parseInt(upper_circle_r)+10)
								.transition()
								.duration(parseInt(interval_time))
								.attr("r",upper_circle_r);
						},2*parseInt(interval_time)+20);
				}
				setInterval(make_inner_invisible,1000);
				/*setInterval(breath, 1500);
				function breath()
				{
					console.log("yes");
					/*
					if already can make sure the boundary,just return
					
					count+=1;
					if(count>15)return;

					//else,let customer wait
					light.attr("fill",color1)
						.transition()
						.duration(740)
						.attr("fill",color2)
						.transition()
						.duration(740)
						.attr("fill",color1);
				}*/
				//setInterval(get_data,1000);
				function draw_circle(arg1)
				{
    					//var breath_rate=parseInt($("#breathrate").html());
    					var breath_rate=parseInt(arg1);
						var standrd=new Array()
						standrd[25]=240
						standrd[24]=290
						standrd[23]=330
						standrd[22]=370
						standrd[21]=420
						standrd[20]=490

						var interval_time=standrd[parseInt(breath_rate)];
    					//light the light
    					inner_circle.attr("stroke-opacity",.6)
								.transition()
								.duration(interval_time)
								.attr("stroke-opacity",.0)
								.transition()
								.duration(interval_time)
								.attr("stroke-opacity",.6);
						upper_circle.attr("r",upper_circle_r)
								.transition()
								.duration(interval_time)
								.attr("r",upper_circle_r+20)
								.transition()
								.duration(parseInt(interval_time))
								.attr("r",upper_circle_r);
				}