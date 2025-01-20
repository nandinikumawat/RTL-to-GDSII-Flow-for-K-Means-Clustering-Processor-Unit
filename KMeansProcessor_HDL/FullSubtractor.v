module FullSubtractor (
    input A, B, Bin,
    output D, Bout
);
    assign D = A ^ B ^ Bin;
    assign Bout = (~A & B) | (Bin & ~A) | (Bin & B);
endmodule

