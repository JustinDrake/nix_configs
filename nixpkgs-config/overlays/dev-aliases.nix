self: super: {
  metals = self.writeShellScriptBin "metals-emacs" ''
    exec ${self.jre8}/bin/java \
      -XX:+UseG1GC \
      -XX:+UseStringDeduplication  \
      -Xss4m \
      -Xms400m \
      -Xmx4G \
      -Dmetals.client=emacs \
      -Dmetals.completion-item.detail=off \
      -jar ${self.coursier}/bin/.coursier-wrapped launch \
      -r bintray:scalameta/maven \
      -r bintray:scalacenter/releases \
      -r sonatype:public \
      org.scalameta:metals_2.12:0.7.2 \
      -M scala.meta.metals.Main
  '';

  nix-dev = self.writeShellScriptBin "nix-dev" ''
    exec nix-shell . -A env "$@"
  '';
}
