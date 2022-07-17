module slever_m(
	sys_clk,
	IRF_1,
	rst_n,
	pwm_en2,
	en_slever,
	IRF_3,
	IRF_2,
	tele_en2,
	pwm_en1,
	pwm_en3,
	tele_en1,
	tele_en3);

	//---Ports declearation: generated by Robei---
	input sys_clk;
	input IRF_1;
	input rst_n;
	output pwm_en2;
	output [2:0] en_slever;
	input IRF_3;
	input IRF_2;
	output [1:0] tele_en2;
	output pwm_en1;
	output pwm_en3;
	output [1:0] tele_en1;
	output [1:0] tele_en3;

	wire sys_clk;
	wire IRF_1;
	wire rst_n;
	reg pwm_en2;
	reg [2:0] en_slever;
	wire IRF_3;
	wire IRF_2;
	reg [1:0] tele_en2;
	reg pwm_en1;
	reg pwm_en3;
	reg [1:0] tele_en1;
	reg [1:0] tele_en3;

	//----Code starts here: integrated by Robei-----
	parameter      SLEVER1 = 800000000;
	parameter      SLEVER2 = 200000000;
	parameter      SLEVER3 = 350000000;
	parameter      SLEVER4 = 450000000;
	parameter      SLEVER5 = 550000000;
	parameter      SLEVER6 = 650000000;
	
	/*
	 //仿真用parameter
	parameter      SLEVER1 = 16;
	parameter      SLEVER2 = 4;
	parameter      SLEVER3 = 7;
	parameter      SLEVER4 = 9;
	parameter      SLEVER5 = 11;
	parameter      SLEVER6 = 14;
	// 仿真用parameter
	*/
	reg         [31:0]         slever_cnt = 0;
	
	/*
	reg                           sign1;
	reg                           sign2;
	reg                           sign3;
	*/
	
	reg                           enslever1;
	reg                           enslever2;
	reg                           enslever3;
	
	wire                         add_sign;
	
	always@(posedge sys_clk) begin
	          if(add_sign) begin
	                 if(slever_cnt == SLEVER1) begin
	                        slever_cnt <= 0;
	                 end  
	                 else begin
	                        slever_cnt = slever_cnt + 1;
	                 end
	          end
	          else begin
	                 slever_cnt <= 0;
	          end
	end
	
	always@(posedge sys_clk ) begin
	         if(IRF_1) begin
	              if(slever_cnt < SLEVER2) begin
	                      enslever1 <= 1;
	              end
	              else if(slever_cnt < SLEVER3) begin
	                      tele_en1 <= 1;
	              end
	              else if(slever_cnt < SLEVER4) begin
	                      pwm_en1 <= 1;
	                      tele_en1 <= 0;                     
	              end
	              else if(slever_cnt < SLEVER5) begin
	                      enslever1 <= 0;                                          
	              end
	              else if(slever_cnt < SLEVER6) begin
	                      enslever1 <= 1;
	                      pwm_en1 <= 0;                                              
	              end
	              else if(slever_cnt < SLEVER1) begin
	                     tele_en1 <= 2;
	              end
	          end 
	          else begin
	                     enslever1 <= 0;  
	                     tele_en1 <= 0;            
	          end         
	end
	
	always@(posedge sys_clk ) begin
	         if(IRF_2) begin
	              if(slever_cnt < SLEVER2) begin
	                      enslever2 <= 1;
	              end
	              else if(slever_cnt < SLEVER3) begin
	                      tele_en2 <= 1;
	              end
	              else if(slever_cnt < SLEVER4) begin
	                      pwm_en2 <= 1;
	                      tele_en2 <= 0;                     
	              end
	              else if(slever_cnt < SLEVER5) begin
	                      enslever2 <= 0;                                          
	              end
	              else if(slever_cnt < SLEVER6) begin
	                      enslever2 <= 1;
	                      pwm_en2 <= 0;                                              
	              end
	              else if(slever_cnt < SLEVER1) begin
	                     tele_en2 <= 2;
	              end
	          end 
	          else begin
	                     enslever2 <= 0;  
	                     tele_en2 <= 0;            
	          end         
	end
	
	always@(posedge sys_clk ) begin
	         if(IRF_3) begin
	              if(slever_cnt < SLEVER2) begin
	                      enslever3 <= 1;
	              end
	              else if(slever_cnt < SLEVER3) begin
	                      tele_en3 <= 1;
	              end
	              else if(slever_cnt < SLEVER4) begin
	                      pwm_en3 <= 1;
	                      tele_en3 <= 0;                     
	              end
	              else if(slever_cnt < SLEVER5) begin
	                      enslever3 <= 0;                                          
	              end
	              else if(slever_cnt < SLEVER6) begin
	                      enslever3 <= 1;
	                      pwm_en3 <= 0;                                              
	              end
	              else if(slever_cnt < SLEVER1) begin
	                     tele_en3 <= 2;
	              end
	          end 
	          else begin
	                     enslever3 <= 0;  
	                     tele_en3 <= 0;            
	          end         
	end
	
	//输出端口位拼接
	always@(posedge sys_clk or posedge rst_n) begin
	      if(!rst_n) begin
		          en_slever <= 3'b000;
		    end
		    else begin
		          en_slever <= {enslever1,enslever2,enslever3};
		    end
	end
	
	//信号综合
	assign  add_sign = IRF_1||IRF_2||IRF_3;
	
endmodule    //slever_m

