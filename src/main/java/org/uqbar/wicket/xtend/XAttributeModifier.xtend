package org.uqbar.wicket.xtend

import org.apache.wicket.Component
import org.apache.wicket.behavior.Behavior
import org.apache.wicket.markup.ComponentTag

/**
 * 
 * @author jfernandes
 */
class XAttributeModifier<T> extends Behavior {
	String attributeName
	(T)=>String closure
	
	new(String attributeName, (T)=>String closure) {
		this.attributeName = attributeName
		this.closure = closure
	}
	
	override onComponentTag(Component component, ComponentTag tag) {
		super.onComponentTag(component, tag)
		val model = component.defaultModelObject
		val attributeValue = closure.apply(model as T)
		
		tag.attributes.put(attributeName, attributeValue)
	}
	
}