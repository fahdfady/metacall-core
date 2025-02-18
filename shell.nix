{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Basic development tools
    pkg-config
    cmake
    gcc
    libclang
    
    # Python for MetaCall
    python3
    
    ruby
    nodejs
    nodejs_22

    # Additional system libraries that might be needed
    openssl
    openssl.dev
    
    # MetaCall dependencies
    libffi
    libffi.dev
    
    llvmPackages.libclang  # Add Clang libraries
    clang    # Full Clang compiler toolkit

    # Tools
    cargo
    rustc
    rust-analyzer

  ];

  shellHook = ''
    export LD_LIBRARY_PATH=/lib:${pkgs.llvmPackages.libclang.lib}/lib:$LD_LIBRARY_PATH
    export CMAKE_LIBRARY_PATH=/lib:${pkgs.llvmPackages.libclang.lib}/lib:$CMAKE_LIBRARY_PATH
    export NODE_PATH=/usr/bin/node
    export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"
     export CLANG_LIBRARY_PATH="${pkgs.llvmPackages.libclang.lib}/lib"
    export CLANG_INCLUDE_PATH="${pkgs.llvmPackages.libclang.dev}/include"
    
    # Extend CMAKE_PREFIX_PATH to help find Clang
    export CMAKE_PREFIX_PATH="${pkgs.llvmPackages.libclang.dev}:${pkgs.llvmPackages.libclang.lib}:$CMAKE_PREFIX_PATH"
    
    # Debug information - this will help us see where CMake should look
    echo "Clang library path: $CLANG_LIBRARY_PATH"
    echo "Clang include path: $CLANG_INCLUDE_PATH"
  '';

}