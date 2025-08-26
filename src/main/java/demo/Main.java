package demo;

import com.structurizr.Workspace;
import com.structurizr.dsl.StructurizrDslParser;

import java.io.File;

/**
 * Validador del DSL de Structurizr
 * Carga y valida el archivo workspace.dsl
 */
public class Main {
    public static void main(String[] args) throws Exception {
        File dsl = new File("src/main/resources/workspace.dsl");
        StructurizrDslParser parser = new StructurizrDslParser();
        parser.parse(dsl);
        Workspace ws = parser.getWorkspace();

        System.out.println("✅ Workspace cargado exitosamente: " + ws.getName());
        System.out.println("✅ DSL validado correctamente");
        System.out.println("📊 Elementos encontrados:");
        System.out.println("   - Personas: " + ws.getModel().getPeople().size());
        System.out.println("   - Sistemas de Software: " + ws.getModel().getSoftwareSystems().size());
        System.out.println("   - Contenedores: " + ws.getModel().getSoftwareSystems().stream()
                .mapToInt(ss -> ss.getContainers().size()).sum());
        System.out.println("   - Componentes: " + ws.getModel().getSoftwareSystems().stream()
                .flatMap(ss -> ss.getContainers().stream())
                .mapToInt(c -> c.getComponents().size()).sum());
    }
}
