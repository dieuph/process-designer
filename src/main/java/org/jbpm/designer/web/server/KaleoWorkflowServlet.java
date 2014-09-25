package org.jbpm.designer.web.server;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.log4j.Logger;
import org.jbpm.designer.web.profile.IDiagramProfile;
import org.jbpm.designer.web.repository.IUUIDBasedRepository;
import org.jbpm.designer.web.repository.IUUIDBasedRepositoryService;
import org.jbpm.designer.web.repository.UUIDBasedEpnRepository;
import org.jbpm.designer.web.repository.impl.UUIDBasedFileRepository;
import org.jbpm.designer.web.repository.impl.UUIDBasedJbpmRepository;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author ]
 * a file based repository that uses the UUID element to save files in individual spots on the file system.
 *
 */
public class KaleoWorkflowServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    private static final Logger _logger = Logger.getLogger(KaleoWorkflowServlet.class);
    
    public static IUUIDBasedRepositoryService _factory = new IUUIDBasedRepositoryService() {

        private Map<String, IUUIDBasedRepository> factories = new HashMap<String, IUUIDBasedRepository>();
        private boolean _init = false;
        
        public void init() {
            factories.put("default", new UUIDBasedFileRepository());
            factories.put("jbpm", new UUIDBasedJbpmRepository());
            factories.put("epn", new UUIDBasedEpnRepository());
            _init = true;
        }
        
        public IUUIDBasedRepository createRepository(ServletConfig config) {
            if(!_init) init();     
            return lookupRepository(config.getInitParameter("factoryName"));
        }
        
        public IUUIDBasedRepository createRepository() {
            return new UUIDBasedFileRepository();
        }
        
        public IUUIDBasedRepository lookupRepository(String name) {
            if(name == null || !factories.containsKey(name)) {
                IUUIDBasedRepository repo =  factories.get("default");
                return repo;
            } else {
                IUUIDBasedRepository repo =  factories.get(name);
                return repo;
            }
        }     
    };
    
    private IUUIDBasedRepository _repository;
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {
            _repository = _factory.createRepository(config);
            _repository.configure(this);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        String uuid = req.getParameter("uuid");
        String preProcessingParam = req.getParameter("pp");
        if (uuid == null) {
            throw new ServletException("uuid parameter required");
        }
        IDiagramProfile profile = ServletUtil.getProfile(req, req.getParameter("profile"), getServletContext());
		try {
			String response =  new String(_repository.load(req, uuid, profile), Charset.forName("UTF-8"));
			resp.getWriter().write(response);
		} catch (Exception e) {
			throw new ServletException("Exception loading process: " + e.getMessage());
		}
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String actionParam = req.getParameter("action");
        String preProcessingParam = req.getParameter("pp");
        if(actionParam != null && actionParam.equals("toKaleo")) {
            IDiagramProfile profile = ServletUtil.getProfile(req, req.getParameter("profile"), getServletContext());
            String json = req.getParameter("data");
            String xml = _repository.toXML(json, profile, preProcessingParam);
            // init
            String path = getServletContext().getRealPath("/xslt/");
            TransformerFactory transFactory = TransformerFactory.newInstance();
            Source xslSource = new StreamSource(new File(path, "BPMN2GPD.xsl"));
            Source xmlSource = new StreamSource(new StringReader(xml));
            Transformer transformer = null;
            StringWriter result = new StringWriter();
            // transforming
            try {
				transformer = transFactory.newTransformer(xslSource);
				transformer.transform(xmlSource, new StreamResult(result));
			} catch (TransformerConfigurationException e) {
				e.printStackTrace();
			} catch (TransformerException e) {
				e.printStackTrace();
			}
            // print out
            StringWriter output = new StringWriter();
            output.write(result.toString());
            resp.setContentType("application/xml");
            resp.setCharacterEncoding("UTF-8");
            resp.setStatus(200);
            resp.getWriter().print(output.toString());
            
        } else if(actionParam != null && actionParam.equals("checkErrors")) { 
        	String retValue = "false";
        	IDiagramProfile profile = ServletUtil.getProfile(req, req.getParameter("profile"), getServletContext());
            String json = req.getParameter("data");
            try {
				String xmlOut = profile.createMarshaller().parseModel(json, preProcessingParam);
				String jsonIn = profile.createUnmarshaller().parseModel(xmlOut, profile, preProcessingParam);
				if(jsonIn == null || jsonIn.length() < 1) {
					retValue = "true";
				}
			} catch (Throwable t) {
				retValue = "true";
				System.out.println("Exception parsing process: " + t.getMessage());
			}
            resp.setContentType("text/plain");
            resp.setCharacterEncoding("UTF-8");
            resp.setStatus(200);
            resp.getWriter().print(retValue);
        } else {
            BufferedReader reader = req.getReader();
            StringWriter reqWriter = new StringWriter();
            char[] buffer = new char[4096];
            int read;
            while ((read = reader.read(buffer)) != -1) {
                reqWriter.write(buffer, 0, read);
            }
        
            String data = reqWriter.toString();
            try {
                JSONObject jsonObject = new JSONObject(data);
            
                String json = (String) jsonObject.get("data");
                String svg = (String) jsonObject.get("svg");
                String uuid = (String) jsonObject.get("uuid");
                String profileName = (String) jsonObject.get("profile");
                boolean autosave = jsonObject.getBoolean("savetype");
            
                IDiagramProfile profile = ServletUtil.getProfile(req, profileName, getServletContext());
            
                _repository.save(req, uuid, json, svg, profile, autosave);

            } catch (JSONException e1) {
                throw new ServletException(e1);
            }
        }
    }
}
