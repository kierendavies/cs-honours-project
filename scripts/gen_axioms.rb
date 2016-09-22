#!/usr/bin/env ruby

require 'singleton'

CLASS_NAMES = %w(C D E F G H I J K)
OBJECT_PROPERTY_NAMES = %w(r s t u v w x y z)

module OneOfSubclasses
  def subclasses
    ObjectSpace.each_object(singleton_class).select { |c| c.superclass == self }
  end

  def all depth
    subclasses.map { |sc| sc.all depth }.flatten
  end
end

module ConcreteExpression
  def initialize *params
    @params = params
  end

  def self.name
    self.class.to_s
  end

  def normalize
    self
  end

  def to_s class_names, object_property_names
    "#{self.class.name}(#{@params.map { |p| p.to_s class_names, object_property_names }.join ' '})"
  end
end

class Axiom
  extend OneOfSubclasses
end

class ClassAxiom < Axiom; end
# class ObjectPropertyAxiom < Axiom; end
# class DataPropertyAxiom < Axiom; end
# class DatatypeDefinition < Axiom; end
# class HasKey < Axiom; end
# class Assertion < Axiom; end
# class AnnotationAxiom < Axiom; end

class SubClassOf < ClassAxiom
  include ConcreteExpression
  def self.all depth
    ClassExpression.all(depth-1).repeated_permutation(2).map do |left, right|
      self.new left, right
    end
  end
end

class EquivalentClasses < ClassAxiom
  include ConcreteExpression
  def self.all depth
    ClassExpression.all(depth-1).repeated_combination(2).map do |left, right|
      self.new left, right
    end
  end
end

class DisjointClasses < ClassAxiom
  include ConcreteExpression
  def self.all depth
    ClassExpression.all(depth-1).repeated_combination(2).map do |left, right|
      self.new left, right
    end
  end
end

class DisjointUnion < ClassAxiom
  include ConcreteExpression
  def self.all depth
    ClassExpression.all(depth-1).repeated_combination(2).map do |left, right|
      self.new ClassLiteral.instance, left, right
    end
  end
end

class ClassExpression
  extend OneOfSubclasses
  def self.all depth
    if depth < 1
      raise
    elsif depth == 1
      ClassLiteral.all 1
    else
      subclasses.map { |sc| sc.all depth }.flatten
    end
  end
end

class ClassLiteral < ClassExpression
  include Singleton

  def self.all depth
    [self.instance]
  end

  def normalize
    self
  end

  def to_s class_names, object_property_names
    class_names.shift
  end
end

class ObjectIntersectionOf < ClassExpression
  include ConcreteExpression
  def self.all depth
    ClassExpression.all(depth-1).repeated_combination(2).map do |left, right|
      self.new left, right
    end
  end
end

class ObjectUnionOf < ClassExpression
  include ConcreteExpression
  def self.all depth
    ClassExpression.all(depth-1).repeated_combination(2).map do |left, right|
      self.new left, right
    end
  end
end

class ObjectComplementOf < ClassExpression
  include ConcreteExpression
  def self.all depth
    ClassExpression.all(depth-1).map do |ce|
      self.new ce
    end
  end
end

# class ObjectOneOf < ClassExpression; end

class ObjectSomeValuesFrom < ClassExpression
  include ConcreteExpression
  def self.all depth
    ObjectPropertyExpression.all(depth-1).map do |pe|
      ClassExpression.all(depth-1).map do |ce|
        self.new pe, ce
      end
    end.flatten
  end
end

class ObjectAllValuesFrom < ClassExpression
  include ConcreteExpression
  def self.all depth
    ObjectPropertyExpression.all(depth-1).map do |pe|
      ClassExpression.all(depth-1).map do |ce|
        self.new pe, ce
      end
    end.flatten
  end
end

# class ObjectHasValue < ClassExpression; end
# class ObjectHasSelf < ClassExpression; end
# class ObjectMinCardinality < ClassExpression; end
# class ObjectMaxCardinality < ClassExpression; end
# class ObjectExactCardinality < ClassExpression; end
# class DataSomeValuesFrom < ClassExpression; end
# class DataAllValuesFrom < ClassExpression; end
# class DataHasValue < ClassExpression; end
# class DataMinCardinality < ClassExpression; end
# class DataMaxCardinality < ClassExpression; end
# class DataExactCardinality < ClassExpression; end

class ObjectPropertyExpression
  extend OneOfSubclasses
  def self.all depth
    if depth < 1
      raise
    elsif depth == 1
      ObjectProperty.all 1
    else
      subclasses.map { |sc| sc.all depth }.flatten
    end
  end
end

class ObjectProperty < ObjectPropertyExpression
  include Singleton

  def self.all depth
    [self.instance]
  end

  def normalize
    self
  end

  def to_s class_names, object_property_names
    object_property_names.shift
  end
end

class ObjectInverseOf < ObjectPropertyExpression
  include ConcreteExpression

  def self.all depth
    ObjectProperty.all(depth).map do |prop|
      self.new prop
    end
  end
end

puts Axiom.all(ARGV[0].to_i).map { |a| a.normalize.to_s CLASS_NAMES.dup, OBJECT_PROPERTY_NAMES.dup }
