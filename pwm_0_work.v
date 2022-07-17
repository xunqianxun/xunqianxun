module pwm_0_work(
	sys_clk,
	pwm_in_1,
	pwm_in_2,
	pwm_out1,
	pwm_out2);

	//---Ports declearation: generated by Robei---
	input sys_clk;
	input pwm_in_1;
	input pwm_in_2;
	output pwm_out1;
	output pwm_out2;

	wire sys_clk;
	wire pwm_in_1;
	wire pwm_in_2;
	reg pwm_out1;
	reg pwm_out2;

	//----Code starts here: integrated by Robei-----
		parameter      siezw1 = 160000;
		parameter      siezw2 = 75000;
		parameter      sieze3 = 50000;
		parameter      size4 = 25000;
		
		
		//reg cnt
		reg         [19:0]       pwm_cnt_woek = 0;
		
		
		//时钟计数信号发生always
		always @(posedge sys_clk) begin
		      if(pwm_cnt_woek == 906255) begin
		             pwm_cnt_woek <= 0;
		      end
		      else begin
		             pwm_cnt_woek = pwm_cnt_woek+1;
		      end
		end
		
		//一路pwm生成快
		always@(posedge sys_clk) begin
		     if(pwm_in_1) begin
		        if(pwm_cnt_woek < siezw2) begin
		               pwm_out1 <= 1;
		        end
		        else begin
		               pwm_out1 <= 0;
		        end
		     end
		     else begin
		          if(pwm_cnt_woek < sieze3) begin
		               pwm_out1 <= 1;
		        end
		        else begin
		               pwm_out1 <= 0;
		        end
		     end
		end 
		
		//二路pwm生成快
		always@(posedge sys_clk) begin
		     if(pwm_in_2) begin
		        if(pwm_cnt_woek < siezw2) begin
		               pwm_out2 <= 1;
		        end
		        else begin
		               pwm_out2 <= 0;
		        end
		     end
		     else begin
		          if(pwm_cnt_woek < size4) begin
		               pwm_out2 <= 1;
		        end
		        else begin
		               pwm_out2 <= 0;
		        end
		     end
		end
	
	
	
endmodule    //pwm_0_work

