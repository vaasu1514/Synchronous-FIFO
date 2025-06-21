module test_bench ;

reg clk,reset,wr_en,rd_en ;
reg [7:0] wr_data;
wire [7:0] rd_data ;
wire full,empty ;

sync_fifo FIFO (clk,reset,wr_data,wr_en,full,rd_data,rd_en,empty) ;

initial
    begin
        clk = 1'b0 ;
        forever 
        #5 clk = ~ clk ;
    end

initial
    begin
        $dumpfile ("Sync_FIFO.vcd") ;
        $dumpvars (0,test_bench) ;
        // $monitor ("mem[%d]",FIFO.mem[0] ) ;
        $monitor("time=%0t, rd_data=%b, empty=%b, full=%b", $time, rd_data, empty, full);



        reset = 1'b1 ;
        #12 ;
        reset = 1'b0 ;

        wr_en = 1 ;

        wr_data = 8'b10010001 ;
        #2 ;
        #7 wr_data = 8'b01011011 ;
        #2 $display("mem[0] = %b", FIFO.mem[0]);

        #7 wr_data = 8'b11111011 ;
        #2 $display("mem[1] = %b", FIFO.mem[1]);

        #12 ;
        $display("mem[2] = %b", FIFO.mem[2]) ;
        wr_en = 0 ;
        rd_en = 1 ;
        #10 ;

        #2 ;

        #200 $finish ;
    end
endmodule