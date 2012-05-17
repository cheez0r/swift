#
# Copyright 2011, Dell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author: andi abes
#

class Evaluator
  
  def initialize(node)
    @b = binding    
  end
  
  def eval_with_context(str)
    eval(str,@b)
  end
  
  def log_eval_vars()
  	eval("Chef::Log.info('locals:'+local_variables.join(':') + '\nglobals:'+global_variables.join(':'))")
  end
  
  def get_ip_by_interface(node, interface)
    if node[:network][:interfaces].has_key?(interface)
      Chef::Log.info("found interface #{interface}")
      my_interface = node[:network][:interfaces][interface]
      address = my_interface[:addresses].select { |a,i| i[:family] == "inet" }
      my_output = address.first[0]
      my_output
    end
  end

  def self.get_ip_by_type(node, type)
    
    ip_location = node[:swift][type]
    e = Evaluator.new(node)
    ip = e.eval_with_context(ip_location)
    Chef::Log.info("Looking at #{ip_location} for #{type} IP addr. Got: #{ip}")
    ip
  end
  
end
