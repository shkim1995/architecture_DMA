`define WORD_SIZE 16
/*************************************************
* DMA module (DMA.v)
* input: clock (CLK), bus grant (BG) signal, 
*        data from the device (edata), and DMA command (cmd)
* output: bus request (BR) signal
*         write enable (WRITE) signal
*         memory address (addr) to be written by the device, 
*         offset device offset (0 - 2)
*         data that will be written to the memory
*         interrupt to notify DMA is end
* You should NOT change the name of the I/O ports and the module name
* You can (or may have to) change the type and length of I/O ports 
* (e.g., wire -> reg) if you want 
* Do not add more ports! 
*************************************************/

module DMA (
    input CLK, BG,
    input [4 * `WORD_SIZE - 1 : 0] edata,
    input[32:0] cmd,
    output BR, WRITE,
    output [`WORD_SIZE - 1 : 0] addr, 
    output [4 * `WORD_SIZE - 1 : 0] data,
    output [1:0] offset,
    output interrupt);

    /* Implement your own logic */
    
    reg BR;
    initial BR <= 0;
    
    reg interrupt;
    initial interrupt <= 0;
    
    wire[15:0] cmd_addr;
    wire[15:0] cmd_len;
    
    reg[15:0] addr;
    reg[15:0] len;
    reg[1:0] offset;
    
    assign cmd_on = cmd[32];
    assign cmd_addr = cmd[31:16];
    assign cmd_len = cmd[15:0];
    
    //cmd is on, the outputs BR
    
    always @(cmd_on) begin
        if(cmd_on) begin
            addr <= cmd_addr;
            len <= cmd_len;
            BR <= 1;
        end
    end
    
    always @(posedge CLK) begin
//        $display("addr : %d", cmd_addr);
//        $display("len : %d", cmd_len);
//        $display("%b", cmd_len==16'bz);
//        $display("%b", cmd_addr==16'bz);
        
        //if cmd is in, then BR on
        
        
        //if BG is on, write on the memory
        if(BG && len > 0) begin
            $display("len : %d", len);
            len <= len - 4;
        end
        
        if(BG && len <= 0) begin
            interrupt <= 1;
        end
    end
    
    //if BG is off
    always @(BG) begin
        if(!BG) begin
            BR<=0;
            interrupt <= 0;
        end
    end

endmodule


