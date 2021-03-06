module ml302_loge(
	sys_clk,
	rst_n,
	IN_tempruter,
	tx_data_in,
	tx_data_valid,
	IN_wate,
	IN_illumination,
	IN_erroe,
	bps_en_tx);

	//---Ports declearation: generated by Robei---
	input sys_clk;
	input rst_n;
	input [7:0] IN_tempruter;
	output [7:0] tx_data_in;
	output tx_data_valid;
	input [7:0] IN_wate;
	input IN_illumination;
	input IN_erroe;
	input bps_en_tx;

	wire sys_clk;
	wire rst_n;
	wire [7:0] IN_tempruter;
	reg [7:0] tx_data_in;
	reg tx_data_valid;
	wire [7:0] IN_wate;
	wire IN_illumination;
	wire IN_erroe;
	wire bps_en_tx;

	//----Code starts here: integrated by Robei-----
	//some state reg
	reg        [4:0]         state = 4'd1; //状态机选择寄存器并初始化发送状态
	reg        [3:0]           cnt_main = 0; //发送数据指令状态寄存器
	reg        [2:0]           cnt_txmd  = 0; //数据发送状态选择寄存器
	//reg                           display_en; //数据接收使能
	//reg        [3:0]            seg_data_r; //云上下发接收数据寄存器
	reg        [2271:0]            char; //指令寄存器
	reg        [11:0]          num;
	reg        [3:0]         data_sned_cnt = 0;
	
	reg        [11:0]        sned_cnt = 0;     
	//some sign upden
	reg        [7:0]          tempruter = 0;
	reg        [7:0]          wate = 0;
	reg        [7:0]          longitude = 117;
	reg        [7:0]          latitude = 34 ;
	reg        [7:0]          illumination = 0;
	reg                         error = 0;
	
	
	always@(posedge sys_clk or posedge rst_n) begin
	        if(!rst_n) begin
	                cnt_main <= 4'd0;
	                state <= 4'd1;
	        end
	        else begin
	        case(state)
	        4'd1: begin
	        if(cnt_main >= 4'd5) 
	              cnt_main <= 4'd5;   
	        else 
	              cnt_main <= cnt_main + 1'b1;
	        case(cnt_main)
	            4'd0: begin 
	                     num<=12'd27; 
	                     char<={"AT+CGDCONT=1",",", 8'h22,"IP",8'h22,",","CMNET",16'h0d0a};
	                     state<=4'd2; 
	                     end
	            4'd1: begin
	                    num<=12'd14;
	                    char<={"AT+CGACT=1",",","1",16'h0d0a};
	                    state <= 4'd2; 
	                    end
	            4'd2: begin
	                     num<=12'd16;
	                     char<={"AT+ALYMQTTOPEN",16'h0d0a};
	                     state<=4'd2;
	                    end
	            4'd3: begin 
	                   num<=12'd78;
	                    char <= {"AT+ALYMQTTSUB",8'h3d,8'h22,8'h2f,"sys",8'h2f,"a1VKgi3anqh",8'h2f,"shebei_zhongduan",8'h2f,"thing",8'h2f,"event",8'h2f,"property",8'h2f,"post",8'h22,",","0",16'h0d0a};
	                    state <= 4'd2;
	                     end
	            4'd4: begin 
	                     num <= 12'd283;
	                     char <= {"AT+ALYMQTTPUBBIN",8'h3d,8'h22,8'h2f,"sys",8'h2f,"a1VKgi3anqh",8'h2f,"shebei_zhongduan",8'h2f,"thing",8'h2f,"event",8'h2f,"property",8'h2f,"post",8'h22,",","0",",",8'h22,8'h7b,8'h22,"id",8'h22,8'h3a,"123456",",",8'h22,"params",8'h22,8'h3a,8'h7b,8'h22,"RelatievHumidity",8'h22,8'h3a,wate,",",8'h22,"CurrenTemperature",8'h22,8'h3a,tempruter,",",8'h22,"mlux",8'h3a,illumination,",",8'h22,"Longitude",8'h22,8'h3a,longitude,",",8'h22,"Latitude",8'h22,8'h3a,latitude,",",8'h22,"LampError",8'h22,8'h3a,error,8'h7d,",",8'h22,"version",8'h22,8'h3a,8'h22,"1",",","0",8'h22,",",8'h22,"method",8'h22,8'h3a,8'h22,"thing",8'h22,",",8'h22,"event",8'h22,",","property",8'h22,",",8'h22,"post",8'h22,8'h7d,8'h22,16'h0d0a};
	                     state <= 4'd2;
	                     end
	            4'd5:  state <= 4'd3; 
	            default: state <= 4'd3;
	        endcase
	                   end
	      4'd2: begin
	          case(cnt_txmd)
	            3'd0: begin
	                    if(!bps_en_tx)   //标注
	                             cnt_txmd <= cnt_txmd; 
	                    else 
	                             cnt_txmd <= cnt_txmd + 1'b1;
	                     end
	            3'd1:   begin
	                            num <= num - 1'b1;
	                            cnt_txmd <= cnt_txmd + 1'b1;
	                       end
	
	            3'd2:   begin
	                         if(sned_cnt == 4500) begin
	                                sned_cnt <= 0;
	                                cnt_txmd <= cnt_txmd + 1'b1;
	                         end
	                         else begin
	                                sned_cnt = sned_cnt +1;
	                          end
	
	                        end
	            3'd3:   begin
	                        //    send_ok_l = 0;
	                            tx_data_valid <= 1'b1; //tx_data_valid为发送数据有效脉冲
	                            tx_data_in <= char[(num*8)+:8];
	                            cnt_txmd <= cnt_txmd + 1'b1;
	                       end
	
	            3'd4:   begin 
	 
	                        tx_data_valid <= 1'b0;
	                        if(num>=1'b1) begin
	                            cnt_txmd <= 3'd0;
	                         end
	                        else begin
	                            cnt_txmd <= cnt_txmd + 1'b1;
	                         end
	                         end
	            3'd5:   begin 
	                            state <= 4'd1; 
	                            cnt_txmd <= 3'd0;
	                         end
	            default: state <= 4'd4;
	        endcase                      
	            end  
	     4'd3: begin
	                 cnt_txmd <= 4'd4;  
	                 state <= 4'd1;
	              end    
	     4'd4: begin
	                 cnt_main <= 3'd0;  
	                 state <= 4'd2;
	              end  
	         default:  state <= state;
	      endcase    
	
	        end
	end
	
	
	
	//sign in
	always@(posedge sys_clk or posedge rst_n) begin
	         if(!rst_n) begin
	              tempruter <=8'b0;
	              wate <=8'b0;
	             // longitude <=8'b0;
	            //  latitude <=8'b0;
	              illumination <=0;
	              error <=0;        
	         end
	         else begin
	              tempruter <= IN_tempruter;
	              wate <= IN_wate;
	             // longitude <= IN_longitude;
	            //  latitude <= IN_latitude;
	              illumination <= IN_illumination;
	              error <= IN_erroe;                
	         end
	end
	
	
	
	
	
	
	
	
endmodule    //ml302_loge

