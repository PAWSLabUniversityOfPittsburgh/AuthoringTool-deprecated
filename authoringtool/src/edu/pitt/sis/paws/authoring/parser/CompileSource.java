package edu.pitt.sis.paws.authoring.parser;
//
//import java.io.Writer;
//import java.net.URI;
import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.Iterator;
//import javax.tools.Diagnostic;
//import javax.tools.DiagnosticCollector;
//import javax.tools.JavaCompiler;
//import javax.tools.JavaCompiler.CompilationTask;
//import javax.tools.JavaFileObject;
//import javax.tools.SimpleJavaFileObject;
//import javax.tools.ToolProvider;
//
////hyun{
////import com.sun.java.util.jar.pack.Package.File;
//
public class CompileSource {
//
//	// hy* public static String compileCode(String code,String jdkAddr)
	public static String compileCode(String code,
			ArrayList<String> importClassCode, ArrayList<String> importClassRealName,
			String jdkAddr) {
//		if (importClassCode == null) {
//			System.out.println("importClassCode = null");
//		}
//		else {
//			// System.out.println("importClassCode array's length: "
//			// + importClassCode.size());
//			if (importClassCode.size() != importClassRealName.size())
//				System.out
//						.println("import class codes and realname dimensions mismatch!");
//		}
//		// System.out.println("main class code:\n" + code);
//		System.setProperty("java.home", jdkAddr);
//		JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
//		DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<JavaFileObject>();
//		// hy* JavaFileObject file = new JavaSourceFromString("code", code);
//		JavaFileObject file = new JavaSourceFromString("Tester", code);
//		Iterable<? extends JavaFileObject> compilationUnits = null;
//		CompilationTask task = null;
//		Writer out = null;
//
//		if (importClassCode != null && importClassCode.size() > 0) {
//			// List<String> optionList = new ArrayList<String>();
//			// optionList.addAll(Arrays.asList("-classpath",
//			// System.getProperty("java.class.path")));
//			ArrayList<JavaFileObject> filesToCompile = new ArrayList<JavaFileObject>();
//			JavaFileObject[] classFiles = new JavaFileObject[importClassCode.size() + 1];
//			// String[] fileNames = new String[importClassCode.size() + 1];
//			filesToCompile.add(file);
//			classFiles[0] = file;
//			// fileNames[0] = "Tester";
//			for (int i = 0; i < importClassCode.size(); i++) {
//				// classFiles[i] = new JavaSourceFromString("code" + i,
//				// importClassCode.get(i - 1));
//				// System.out.println("importClassRealName:" +
//				// importClassRealName.get(i)
//				// + "\n");// + importClassCode.get(i));
//				classFiles[i + 1] = new JavaSourceFromString(
//						importClassRealName.get(i), importClassCode.get(i));
//				filesToCompile.add(classFiles[i + 1]);
//				// fileNames[i + 1] = importClassRealName.get(i);
//				// + ((i == importClassCode.size() - 1) ? "" : File.separator);
//			}
//			// Iterable<String> filesToCompile = Arrays.asList(fileNames);
//			// Iterable<? extends File> filesToCompile = Arrays.asList(classFiles);
//
//			// compilationUnits = fileManager
//			// .getJavaFileObjectsFromStrings(filesToCompile);
//			compilationUnits = filesToCompile;
//			// compilationUnits = fileManager.getJavaFileObjects(classFiles);
//			// compilationUnits = Arrays.asList(classFiles);
//
//			if (compilationUnits == null)
//				System.out.println("compilatinUnits == null!");
//			else {
//				Iterator<? extends JavaFileObject> iter = compilationUnits.iterator();
//				// for debugging
//				// while (null != iter && iter.hasNext()) {
//				// // System.out.print("adding...");
//				// Kind k = iter.next().getKind(); // Possible ClassCastException @
//				// // runtime
//				// // System.out.println(k);
//				// }
//
//				task = compiler.getTask(out, null, diagnostics, null, null,
//						compilationUnits);
//				// task = compiler.getTask(out, null, diagnostics, optionList, null,
//				// compilationUnits);
//			}
//		}
//		else {
//			compilationUnits = Arrays.asList(file);
//			task = compiler.getTask(null, null, diagnostics, null, null,
//					compilationUnits);
//		}
//		boolean success = task.call();
//		// System.out.println("success: " + success);
		String message = "";
//		if (success == false) {
//			String tmp;
//			int offset;
//			for (Diagnostic diagnostic : diagnostics.getDiagnostics()) {
//				if (diagnostic.getKind() == Diagnostic.Kind.ERROR) {
//					tmp = diagnostic.getMessage(null);
//					// hy*
//					// if (!tmp.contains("should be declared in a file named")) {
//					// offset = tmp.indexOf(".java:", 0);
//					// if (offset != -1) {
//					// tmp = tmp.substring(offset + 6);
//					// message += "Line ";
//					// }
//					// }
//					// else {
//					// message += "Please name the main class as Tester!";
//					// }
//					// *hy
//					// TODO: or name the imported class correctly
//					if (tmp.contains("should be declared in a file named")) {
//						message += "Please name your class as Tester (Tester.java refers to your class in following error messages);\n\n";
//						// TODO: currenlty, assume the error only comes from main class,
//						// user can do nothing about the imported class's name
//						continue;
//					}
//					message += tmp + ";\n";
//				}
//			}
//		}
//		// System.out.println("message: " + message + "\nmessage length:"
//		// + message.length());
		return message;
//	}
}
//
//// }hy
//
//class JavaSourceFromString extends SimpleJavaFileObject {
//	final String code;
//
//	JavaSourceFromString(String name, String code) {
//		super(URI.create(name.replace('.', '/') + Kind.SOURCE.extension),
//				Kind.SOURCE);
//		this.code = code;
//	}
//
//	@Override
//	public CharSequence getCharContent(boolean ignoreEncodingErrors) {
//		return code;
//	}
}