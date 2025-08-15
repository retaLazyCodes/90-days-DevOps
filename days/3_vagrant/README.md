# Vagrant: Entorno de desarrollo

### **📝 Explicación:**

- **`config.vm.box`**: Imagen base (Ubuntu en este caso).
- **`config.vm.network`**: Asigna IP privada.
- **`config.vm.provision`**: Ejecuta comandos Shell al iniciar.

---

### **🚀 Comandos Clave de Vagrant**

| **Comando** | **Descripción** |
| --- | --- |
| `vagrant init` | Crea un Vagrantfile básico |
| `vagrant up` | Inicia la VM (+ provisionamiento) |
| `vagrant ssh` | Conéctate a la VM por SSH |
| `vagrant halt` | Apaga la VM |
| `vagrant destroy` | Elimina la VM (¡cuidado!) |
| `vagrant provision` | Re-ejecuta el provisionamiento |