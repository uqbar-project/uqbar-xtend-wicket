package org.uqbar.wicket.xtend

import java.io.Serializable
import org.apache.wicket.Component
import org.apache.wicket.MarkupContainer
import org.apache.wicket.markup.html.basic.Label
import org.apache.wicket.markup.html.form.ChoiceRenderer
import org.apache.wicket.markup.html.form.Form
import org.apache.wicket.markup.html.form.TextField
import org.apache.wicket.markup.html.panel.FeedbackPanel
import org.apache.wicket.model.CompoundPropertyModel
import org.apache.wicket.model.LoadableDetachableModel
import org.apache.wicket.validation.IValidationError
import org.apache.wicket.validation.ValidationError
import org.eclipse.jdt.annotation.Nullable
import org.eclipse.xtext.xbase.lib.Functions.Function0
import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import org.uqbar.commons.model.Entity
import org.uqbar.commons.model.Home
import org.uqbar.commons.utils.ApplicationContext
import org.eclipse.xtext.xbase.lib.Procedures.Procedure0
import org.uqbar.commons.model.UserException

/**
 * Wicket extension methods to make it easy to use in xtend.
 * Also using all the power that comes with xtend like extension methods, closures, etc.
 */
class WicketExtensionFactoryMethods implements Serializable {
	
	// **************************************
	// ** generic extension methods
	// **************************************
	
	def <M> asCompoundModel(M aModelObject) {
		new CompoundPropertyModel<M>(aModelObject)
	}
	
	def <T extends Entity> Home<T> home(Class<T> aType) {
		return ApplicationContext.instance.getSingleton(aType)
	}
	
	def IValidationError asValidationError(String aMessage) {
		new ValidationError() => [
			message = aMessage
		]
	}
	
	def apply(Component component, Procedure0 procedure) {
		try {
			procedure.apply
		} catch (UserException e) {
			component.error(e.message.asValidationError)
		}
	}
	
	// **************************************
	// ** builder methods
	// **************************************	
	
	def addChild(MarkupContainer container, Component child) {
		container.add(child)
	}
	
	def label(MarkupContainer container, String id) {
		label(container, id, [])
	}
	
	def label(MarkupContainer container, String id, @Nullable Procedure1<Label> p) {
		addLabel(container, id, p)
	}
	
	def feedbackPanel(MarkupContainer container, String id) {
		feedbackPanel(container, id, [])
	}
	
	def feedbackPanel(MarkupContainer container, String id, @Nullable Procedure1<FeedbackPanel> p) {
		addIt(container, new FeedbackPanel(id), p)
	}
	
	def button(MarkupContainer container, String id, @Nullable Procedure1<XButton> p) {
		addIt(container, new XButton(id), p)
	}
	
	def addLabel(MarkupContainer container, String id, @Nullable Procedure1<Label> p) {
		addIt(container, new Label(id), p)
	}
	
	def <M> form(MarkupContainer container, String id, @Nullable Procedure1<Form<M>> p) {
		addIt(container, new Form(id), p)
	}
	
	def <T> textField(MarkupContainer container, String id) {
		textField(container, id, [])
	}
	
	def <T> textField(MarkupContainer container, String id, @Nullable Procedure1<TextField<T>> p) {
		addTextField(container, id, p)
	}
	
	def <T> addTextField(MarkupContainer container, String id, @Nullable Procedure1<TextField<T>> p) {
		addIt(container, new TextField(id), p)
	}
	
	def <C extends Component> addIt(MarkupContainer container, C component, @Nullable Procedure1<C> p) {
		container.add(component)
		if (p != null) {
			p.apply(component)
		}
		component
	}
	
	// *************************************************
	// ** factory methods for wicket objects to be used
	// ** with closures (blocks)
	// *************************************************
		
	def <T> LoadableDetachableModel<T> loadableModel(Function0<T> function) {
		new XLoadableDetachableModel<T>(function)
	}
	
	def <M> ChoiceRenderer<M> choiceRenderer(Function1<M,?> function) {
		new XChoiceRenderer<M>(function)
	}
	
}

/**
 * Subclasses LoadableDetachableModel to delegate the load method to a function
 * object so it can be used with xtend closures.
 * @author jfernandes
 */
class XLoadableDetachableModel<T> extends LoadableDetachableModel<T> {
	Function0<T> function
	new(Function0<T> aFunction) {
		function = aFunction
	}
	
	override protected load() {
		return function.apply		
	}
}

class XChoiceRenderer<M> extends ChoiceRenderer<M> {
	Function1<M,?> function
	new(Function1<M,?> aFunction) {
		function = aFunction
	}
	override getDisplayValue(M object) {
		function.apply(object)
	}
}