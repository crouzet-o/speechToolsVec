delay = round(t2s(100,fs));
z_desync = zeros(8,28409+delay);
z_desync(1,:) = [z(1,:),zeros(1,delay)];
z_desync(2,:) = [zeros(1,delay/2),z(2,:),zeros(1,delay/2)];
z_desync(3,:) = [zeros(1,delay),z(3,:)];
z_desync(4,:) = [zeros(1,delay/2),z(4,:),zeros(1,delay/2)];
z_desync(5,:) = [z(5,:),zeros(1,delay)];
z_desync(6,:) = [zeros(1,delay/2),z(6,:),zeros(1,delay/2)];
z_desync(7,:) = [zeros(1,delay),z(7,:)];
z_desync(8,:) = [z(8,:),zeros(1,delay)];

