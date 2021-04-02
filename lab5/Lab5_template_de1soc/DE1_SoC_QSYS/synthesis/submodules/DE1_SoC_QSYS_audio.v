// DE1_SoC_QSYS_audio.v

// Generated using ACDS version 14.1 186 at 2021.04.02.14:16:03

`timescale 1 ps / 1 ps
module DE1_SoC_QSYS_audio (
		input  wire        clk_clk,                      //               clk.clk
		output wire [31:0] data_divfrec_export,          //      data_divfrec.export
		input  wire [1:0]  data_fregen_s1_address,       //    data_fregen_s1.address
		input  wire        data_fregen_s1_write_n,       //                  .write_n
		input  wire [31:0] data_fregen_s1_writedata,     //                  .writedata
		input  wire        data_fregen_s1_chipselect,    //                  .chipselect
		output wire [31:0] data_fregen_s1_readdata,      //                  .readdata
		input  wire        empty_export,                 //             empty.export
		input  wire [1:0]  empty_s1_address,             //          empty_s1.address
		output wire [31:0] empty_s1_readdata,            //                  .readdata
		input  wire        fifo_full_export,             //         fifo_full.export
		input  wire [1:0]  fifo_full_s1_address,         //      fifo_full_s1.address
		output wire [31:0] fifo_full_s1_readdata,        //                  .readdata
		input  wire [11:0] fifo_used_export,             //         fifo_used.export
		input  wire [1:0]  fifo_used_s1_address,         //      fifo_used_s1.address
		output wire [31:0] fifo_used_s1_readdata,        //                  .readdata
		output wire [31:0] out_data_audio_export,        //    out_data_audio.export
		input  wire [1:0]  out_data_audio_s1_address,    // out_data_audio_s1.address
		input  wire        out_data_audio_s1_write_n,    //                  .write_n
		input  wire [31:0] out_data_audio_s1_writedata,  //                  .writedata
		input  wire        out_data_audio_s1_chipselect, //                  .chipselect
		output wire [31:0] out_data_audio_s1_readdata,   //                  .readdata
		output wire        out_pause_export,             //         out_pause.export
		input  wire [1:0]  out_pause_s1_address,         //      out_pause_s1.address
		input  wire        out_pause_s1_write_n,         //                  .write_n
		input  wire [31:0] out_pause_s1_writedata,       //                  .writedata
		input  wire        out_pause_s1_chipselect,      //                  .chipselect
		output wire [31:0] out_pause_s1_readdata,        //                  .readdata
		output wire        out_stop_export,              //          out_stop.export
		input  wire [1:0]  out_stop_s1_address,          //       out_stop_s1.address
		input  wire        out_stop_s1_write_n,          //                  .write_n
		input  wire [31:0] out_stop_s1_writedata,        //                  .writedata
		input  wire        out_stop_s1_chipselect,       //                  .chipselect
		output wire [31:0] out_stop_s1_readdata,         //                  .readdata
		input  wire        reset_reset_n,                //             reset.reset_n
		output wire        wrclk_export,                 //             wrclk.export
		input  wire [1:0]  wrclk_s1_address,             //          wrclk_s1.address
		input  wire        wrclk_s1_write_n,             //                  .write_n
		input  wire [31:0] wrclk_s1_writedata,           //                  .writedata
		input  wire        wrclk_s1_chipselect,          //                  .chipselect
		output wire [31:0] wrclk_s1_readdata,            //                  .readdata
		output wire        wrreq_export,                 //             wrreq.export
		input  wire [1:0]  wrreq_s1_address,             //          wrreq_s1.address
		input  wire        wrreq_s1_write_n,             //                  .write_n
		input  wire [31:0] wrreq_s1_writedata,           //                  .writedata
		input  wire        wrreq_s1_chipselect,          //                  .chipselect
		output wire [31:0] wrreq_s1_readdata             //                  .readdata
	);

	DE1_SoC_QSYS_audio_DATA_FREGEN data_fregen (
		.clk        (clk_clk),                   //                 clk.clk
		.reset_n    (reset_reset_n),             //               reset.reset_n
		.address    (data_fregen_s1_address),    //                  s1.address
		.write_n    (data_fregen_s1_write_n),    //                    .write_n
		.writedata  (data_fregen_s1_writedata),  //                    .writedata
		.chipselect (data_fregen_s1_chipselect), //                    .chipselect
		.readdata   (data_fregen_s1_readdata),   //                    .readdata
		.out_port   (data_divfrec_export)        // external_connection.export
	);

	DE1_SoC_QSYS_audio_EMPTY empty (
		.clk      (clk_clk),           //                 clk.clk
		.reset_n  (reset_reset_n),     //               reset.reset_n
		.address  (empty_s1_address),  //                  s1.address
		.readdata (empty_s1_readdata), //                    .readdata
		.in_port  (empty_export)       // external_connection.export
	);

	DE1_SoC_QSYS_audio_EMPTY fifo_full (
		.clk      (clk_clk),               //                 clk.clk
		.reset_n  (reset_reset_n),         //               reset.reset_n
		.address  (fifo_full_s1_address),  //                  s1.address
		.readdata (fifo_full_s1_readdata), //                    .readdata
		.in_port  (fifo_full_export)       // external_connection.export
	);

	DE1_SoC_QSYS_audio_DATA_FREGEN out_data_audio (
		.clk        (clk_clk),                      //                 clk.clk
		.reset_n    (reset_reset_n),                //               reset.reset_n
		.address    (out_data_audio_s1_address),    //                  s1.address
		.write_n    (out_data_audio_s1_write_n),    //                    .write_n
		.writedata  (out_data_audio_s1_writedata),  //                    .writedata
		.chipselect (out_data_audio_s1_chipselect), //                    .chipselect
		.readdata   (out_data_audio_s1_readdata),   //                    .readdata
		.out_port   (out_data_audio_export)         // external_connection.export
	);

	DE1_SoC_QSYS_audio_OUT_PAUSE out_pause (
		.clk        (clk_clk),                 //                 clk.clk
		.reset_n    (reset_reset_n),           //               reset.reset_n
		.address    (out_pause_s1_address),    //                  s1.address
		.write_n    (out_pause_s1_write_n),    //                    .write_n
		.writedata  (out_pause_s1_writedata),  //                    .writedata
		.chipselect (out_pause_s1_chipselect), //                    .chipselect
		.readdata   (out_pause_s1_readdata),   //                    .readdata
		.out_port   (out_pause_export)         // external_connection.export
	);

	DE1_SoC_QSYS_audio_OUT_PAUSE out_stop (
		.clk        (clk_clk),                //                 clk.clk
		.reset_n    (reset_reset_n),          //               reset.reset_n
		.address    (out_stop_s1_address),    //                  s1.address
		.write_n    (out_stop_s1_write_n),    //                    .write_n
		.writedata  (out_stop_s1_writedata),  //                    .writedata
		.chipselect (out_stop_s1_chipselect), //                    .chipselect
		.readdata   (out_stop_s1_readdata),   //                    .readdata
		.out_port   (out_stop_export)         // external_connection.export
	);

	DE1_SoC_QSYS_audio_OUT_PAUSE wrclk (
		.clk        (clk_clk),             //                 clk.clk
		.reset_n    (reset_reset_n),       //               reset.reset_n
		.address    (wrclk_s1_address),    //                  s1.address
		.write_n    (wrclk_s1_write_n),    //                    .write_n
		.writedata  (wrclk_s1_writedata),  //                    .writedata
		.chipselect (wrclk_s1_chipselect), //                    .chipselect
		.readdata   (wrclk_s1_readdata),   //                    .readdata
		.out_port   (wrclk_export)         // external_connection.export
	);

	DE1_SoC_QSYS_audio_OUT_PAUSE wrreq (
		.clk        (clk_clk),             //                 clk.clk
		.reset_n    (reset_reset_n),       //               reset.reset_n
		.address    (wrreq_s1_address),    //                  s1.address
		.write_n    (wrreq_s1_write_n),    //                    .write_n
		.writedata  (wrreq_s1_writedata),  //                    .writedata
		.chipselect (wrreq_s1_chipselect), //                    .chipselect
		.readdata   (wrreq_s1_readdata),   //                    .readdata
		.out_port   (wrreq_export)         // external_connection.export
	);

	DE1_SoC_QSYS_audio_fifo_used fifo_used (
		.clk      (clk_clk),               //                 clk.clk
		.reset_n  (reset_reset_n),         //               reset.reset_n
		.address  (fifo_used_s1_address),  //                  s1.address
		.readdata (fifo_used_s1_readdata), //                    .readdata
		.in_port  (fifo_used_export)       // external_connection.export
	);

endmodule
