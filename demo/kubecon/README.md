# Getting Started with Hubble

1. create kind cluster

```yaml
kind create cluster --config=kind-config.yaml
```

2. install cilium with cli

```yaml
cilium install --version 1.15.2
```

3. check Cilium status and wait for Cilium to be ready

```yaml
cilium status --wait
```

4. Enable hubble

```yaml
cilium hubble enable
```

5. port forward hubble in a seperate tab
```yaml
kubectl port-forward -n kube-system service/hubble-relay 4245:80
```

6. Enable  hubble ui

```yaml
cilium hubble enable --ui
```

7. start hubble ui

```yaml
cilium hubble ui
```


8. deploy demo app

```yaml
kubectl apply -f apps.yaml
```

9. Check if all pods are running

```yaml
k get pods
```

10. expose deployments and make sure the port of the service isn’t 80 as hubble-ui listens on port 80

```yaml
kubectl expose deployment app1 --type=NodePort --port=8081 --target-port=80 --name=app1-service
kubectl expose deployment app2 --type=NodePort --port=8082 --target-port=80 --name=app2-service

```

11. get app 1

```yaml
kubectl get pods -l app=app1
```

12. Go into app 1 pod to generate some traffic that Hubble can read

```yaml
kubectl exec -it <app1-pod-name> -- /bin/bash
```

13. generate traffic with curl using k8s DNS

```yaml
curl http://<pod-ip>:<pod-port>
curl google.com
```

14. observe locally

```yaml
hubble observe --namespace default --follow
```

15. head to Hubble ui and observe the default namespace

```yaml
http://localhost:12000/?namespace=default
```

16. apply a cilium network policy to block app1 from connecting to app2

```yaml
kubectl apply -f default-deny
```

17. exec into app1 pod and try to call again

```yaml
curl http://pod-ip:pod-port
curl google.com
```

18. Observe Hubble cli and ui

19. delete the default-deny Cilium Network Policy

```yaml
kubectl delete cnp default-deny
```

20. Observe Hubble cli and ui

21. apply L7 visibility with a cilium network policy

```yaml
kubectl apply -f l7-visibility.yaml
```

22. Observe Hubble cli and ui for the Layer 7 properties
