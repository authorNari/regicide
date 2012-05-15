module Regicide
  class BuildTimeConfig < org.mmtk.vm.BuildTimeConfig
    def getPlanName
      return java.lang.System.get_property("mmtk.regicide.plan")
    end

    def getStringProperty(name)
      return java.lang.System.get_property(name)
    end

    def getStringProperty(name, default)
      default = nil unless default.is_a?(String)
      return java.lang.System.get_property(name, default.to_s)
    end

    def getIntProperty(name)
      reutrn java.lang.Integer.parse_int(getStringProperty(name))
    end

    def getIntProperty(name, default)
      v = getStringProperty(name, default)
      if v == nil
        default
      else
        java.lang.Integer.parse_int(v)
      end
    end

    def getBooleanProperty(name)
      reutrn java.lang.Boolean.parse_boolean(getStringProperty(name))
    end

    def getBooleanProperty(name, default)
      v = getStringProperty(name, default)
      if v == nil
        default
      else
       java.lang.Boolean.parse_boolean(v)
      end
    end
  end
end
