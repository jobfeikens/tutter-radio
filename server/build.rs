fn main() {
    protobuf_codegen::Codegen::new()
        .protoc()
        .includes(&["../protos"])
        .input("../protos/message.proto")
        .cargo_out_dir("generated")
        .run_from_script();
}