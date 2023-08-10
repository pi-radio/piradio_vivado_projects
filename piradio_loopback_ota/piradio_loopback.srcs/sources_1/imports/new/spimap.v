module SPIMAP #(
        parameter NCSN = 29
    ) (
    input [NCSN-1:0] csn,
    output spi_dev_0,
    output spi_dev_1,
    output spi_dev_2,
    output spi_card_0,
    output spi_card_1,
    output spi_card_en,
    output locsn
    );
    wire [6:0] sel_mask;

// card en card sel 0 card sel 1 dev sel 2 dev sel 1 dev sel 0

assign spi_dev_0 = sel_mask[0];
assign spi_dev_1 = sel_mask[1];
assign spi_dev_2 = sel_mask[2];

assign spi_card_0 = sel_mask[3];
assign spi_card_1 = sel_mask[4];

assign spi_card_en = sel_mask[5];

assign locsn = sel_mask[6];

                  // Card 0
assign sel_mask = (csn[ 0] == 0) ? 7'b1_1_00_000 :
                  (csn[ 1] == 0) ? 7'b1_1_00_001 :
                  (csn[ 2] == 0) ? 7'b1_1_00_010 :
                  (csn[ 3] == 0) ? 7'b1_1_00_011 :
                  (csn[ 4] == 0) ? 7'b1_1_00_100 :
                  (csn[ 5] == 0) ? 7'b1_1_00_101 :
                  // Card 1
                  (csn[ 6] == 0) ? 7'b1_1_01_000 :
                  (csn[ 7] == 0) ? 7'b1_1_01_001 :
                  (csn[ 8] == 0) ? 7'b1_1_01_010 :
                  (csn[ 9] == 0) ? 7'b1_1_01_011 :
                  (csn[10] == 0) ? 7'b1_1_01_100 :
                  (csn[11] == 0) ? 7'b1_1_01_101 :
                  // Card 2
                  (csn[12] == 0) ? 7'b1_1_10_000 :
                  (csn[13] == 0) ? 7'b1_1_10_001 :
                  (csn[14] == 0) ? 7'b1_1_10_010 :
                  (csn[15] == 0) ? 7'b1_1_10_011 :
                  (csn[16] == 0) ? 7'b1_1_10_100 :
                  (csn[17] == 0) ? 7'b1_1_10_101 :
                  // Card 3
                  (csn[18] == 0) ? 7'b1_1_11_000 :
                  (csn[19] == 0) ? 7'b1_1_11_001 :
                  (csn[20] == 0) ? 7'b1_1_11_010 :
                  (csn[21] == 0) ? 7'b1_1_11_011 :
                  (csn[22] == 0) ? 7'b1_1_11_100 :
                  (csn[23] == 0) ? 7'b1_1_11_101 :
                  // LMX
                  (csn[24] == 0) ? 7'b0_0_00_111 :
                  7'b1_0_00_000;
endmodule