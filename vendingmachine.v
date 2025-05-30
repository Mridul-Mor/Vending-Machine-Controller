module vending_machine (
    input clk, reset,
    input coin_1, coin_2,
    output reg item_dispensed,
    output reg change
);

    // State encoding using parameters
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;

    reg [2:0] current_state, next_state;

    // State transition and registered outputs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            item_dispensed <= 0;
            change <= 0;
        end else begin
            current_state <= next_state;
            // Register the outputs to hold for one clock cycle
            case (current_state)
                S0: begin
                    item_dispensed <= 0;
                    change <= 0;
                end
                S1: begin
                    item_dispensed <= 0;
                    change <= 0;
                end
                S2: begin
                    item_dispensed <= 0;
                    change <= 0;
                end
                S3: begin
                    if (coin_2) begin
                        item_dispensed <= 1; // Dispense item (₹5 reached)
                        change <= 0;
                    end else begin
                        item_dispensed <= 0;
                        change <= 0;
                    end
                end
                S4: begin
                    if (coin_1) begin
                        item_dispensed <= 1; // Dispense item (₹5 reached)
                        change <= 0;
                    end else if (coin_2) begin
                        item_dispensed <= 1; // Dispense item
                        change <= 1; // Extra ₹1 as change (₹6 - ₹5)
                    end else begin
                        item_dispensed <= 0;
                        change <= 0;
                    end
                end
                S5: begin
                    if (coin_1 || coin_2) begin
                        item_dispensed <= 1;
                        change <= 1; // Always give change in S5
                    end else begin
                        item_dispensed <= 0;
                        change <= 0;
                    end
                end
                default: begin
                    item_dispensed <= 0;
                    change <= 0;
                end
            endcase
        end
    end

    // Next state logic (combinatorial)
    always @(*) begin
        next_state = current_state;

        case (current_state)
            S0: begin
                if (coin_1) next_state = S1;
                else if (coin_2) next_state = S2;
            end
            S1: begin
                if (coin_1) next_state = S2;
                else if (coin_2) next_state = S3;
            end
            S2: begin
                if (coin_1) next_state = S3;
                else if (coin_2) next_state = S4;
            end
            S3: begin
                if (coin_1) next_state = S4;
                else if (coin_2) next_state = S0; // Return to S0 after dispensing
            end
            S4: begin
                if (coin_1 || coin_2) next_state = S0; // Return to S0 after dispensing
            end
            S5: begin
                if (coin_1 || coin_2) next_state = S0;
            end
            default: next_state = S0;
        endcase
    end
endmodule