package org.jbpm.designer.bpmn2;

import java.util.Map;

import org.eclipse.bpmn2.BaseElement;

/**
 * A helper to marshall specific properties of the Process Designer models,
 * to translate them into BPMN 2 constraints.
 *
 */
public interface BpmnMarshallerHelper {
    
    /**
     * Applies the set of properties from the json model to the BPMN 2 element.
     * @param baseElement the base element to be customized.
     * @param properties the set of properties extracted from the json model.
     */
    public void applyProperties(BaseElement baseElement, Map<String, String> properties);

}
