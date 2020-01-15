self: super: {
  scala = super.scala_2_12;

  metals = self.writeShellScriptBin "metals-emacs" ''
    exec ${self.openjdk12_headless}/bin/java \
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
      org.scalameta:metals_2.12:0.8.0 \
      -M scala.meta.metals.Main
  '';
}
