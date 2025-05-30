`timescale 1ns / 1ps

module vending_machine_tb;

    // Inputs
    reg clk, reset, coin_1, coin_2;

    // Outputs
    wire item_dispensed, change;

    // Instantiate the Unit Under Test (UUT)
    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin_1(coin_1),
        .coin_2(coin_2),
        .item_dispensed(item_dispensed),
        .change(change)
    );

    // Clock generation (period = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        coin_1 = 0;
        coin_2 = 0;

        // Hold reset for a few clock cycles
        #15 reset = 0;

        // Scenario 1: Insert ₹2, ₹1, ₹2 (Total ₹5)
        $display("Starting Scenario 1: ₹2 + ₹1 + ₹2");
        #10; coin_2 = 1; #10; coin_2 = 0;
        #10; coin_1 = 1; #10; coin_1 = 0;
        #10; coin_2 = 1; #10; coin_2 = 0;
        #20; // Observe item_dispensed and change
        $display("Scenario 1 done.");

        // Reset before next scenario
        reset_machine();

        // Scenario 2: Insert ₹1 five times (Total ₹5)
        $display("Starting Scenario 2: ₹1 * 5");
        #10; coin_1 = 1; #10; coin_1 = 0;
        #10; coin_1 = 1; #10; coin_1 = 0;
        #10; coin_1 = 1; #10; coin_1 = 0;
        #10; coin_1 = 1; #10; coin_1 = 0;
        #10; coin_1 = 1; #10; coin_1 = 0;
        #20; // Observe outputs
        $display("Scenario 2 done.");

        // Reset before next scenario
        reset_machine();

        // Scenario 3: Insert ₹2 three times (Total ₹6)
        $display("Starting Scenario 3: ₹2 * 3");
        #10; coin_2 = 1; #10; coin_2 = 0;
        #10; coin_2 = 1; #10; coin_2 = 0;
        #10; coin_2 = 1; #10; coin_2 = 0;
        #20; // Observe outputs
        $display("Scenario 3 done.");

        // Reset before next scenario
        reset_machine();

        // Finish simulation
        #50;
        $finish;
    end

    // Task to reset the machine
    task reset_machine;
    begin
        $display("Resetting vending machine...");
        reset = 1; coin_1 = 0; coin_2 = 0;
        #20; // Hold reset high for a few cycles
        reset = 0;
        #10; // Allow system to stabilize
        $display("Reset complete.");
    end
    endtask

endmodule