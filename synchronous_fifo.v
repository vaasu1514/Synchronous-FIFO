module sync_fifo (clk,reset,wr_data,wr_en,full,rd_data,rd_en,empty) ;

input clk,reset,wr_en,rd_en ;
input [7:0] wr_data;
output reg [7:0] rd_data ;
output full,empty ;

reg [6:0] wr_ptr,rd_ptr ;
reg [6:0] count ;
reg [7:0] mem [0:63] ;  // Memory FIFO

assign full = (count == 64) ; // this checks for the status flag
assign empty = (count == 0) ;
 
always @ (posedge clk)     // this always block manages fifo counter
    begin
        if (reset)
            count <= 0 ;
        else if ((!full && wr_en) && (!empty && rd_en))  // if read and write is done simultaneously at the same posedge of clk then effectively the count remains same as before
            count <= count ;
        else if (!full && wr_en) 
            count <= count + 1 ;
        else if (!empty && rd_en)
            count <= count -1 ;
        else 
            count <= count ;  
    end

// ***** READ OPERATION ***** 
always @ (posedge clk)
    begin
        if (reset)
            rd_data <= 0 ;
        else if (!empty && rd_en)
            rd_data <= mem[rd_ptr] ;
        else 
            rd_data <= rd_data ;    
    end

// ***** WRITE OPERATION ***** 
always @ (posedge clk)
    begin 
        if (!full && wr_en)
            mem[wr_ptr] <= wr_data ;
        else 
            mem[wr_ptr] <= mem[wr_ptr] ;
    end

// ***** MOVEMENT OF POINTERS *****
always @ (posedge clk)
    begin
        if (reset)
            begin
                wr_ptr <= 0 ;
                rd_ptr <= 0 ;
            end
        else
            begin
                if (!full && wr_en)    // write pointer
                    wr_ptr <= (wr_ptr == 63) ? 0 : wr_ptr + 1 ;
                else 
                    wr_ptr <= wr_ptr ;
                
                if (!empty && rd_en)  // read pointer
                    rd_ptr <= (rd_ptr == 63) ? 0 : rd_ptr + 1 ;
                else
                    rd_ptr <= rd_ptr ;    

            end    
    end
endmodule