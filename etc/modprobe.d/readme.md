# Note
- `nvidia-suspend.service` is disabled by default while Arch wiki says it’s should be enabled by default. Same with `nvidia-hibernate.service`. Check the status and enable it, e.g. `sudo systemctl enable nvidia-suspend.service`.
```
❯ systemctl list-unit-files | grep nvidia
nvidia-hibernate.service                     enabled         disabled
nvidia-persistenced.service                  disabled        disabled
nvidia-powerd.service                        disabled        disabled
nvidia-resume.service                        enabled         disabled
nvidia-suspend-then-hibernate.service        disabled        disabled
nvidia-suspend.service                       enabled         disabled
```
- Place [nvidia.conf](./nvidia.conf) at `/etc/modprobe.d/nvidia.conf`
- Keep an eye out - https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472
