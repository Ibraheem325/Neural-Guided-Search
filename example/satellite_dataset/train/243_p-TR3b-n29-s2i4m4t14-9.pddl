(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	infrared0 - mode
	spectrograph1 - mode
	infrared2 - mode
	image3 - mode
	GroundStation3 - direction
	GroundStation11 - direction
	Star12 - direction
	Star8 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	Star13 - direction
	GroundStation0 - direction
	GroundStation7 - direction
	Star6 - direction
	GroundStation9 - direction
	Star5 - direction
	Star14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation7)
	(supports instrument1 infrared2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 GroundStation9)
	(supports instrument2 image3)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument3 image3)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star13)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation4)
	(supports instrument4 spectrograph1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 GroundStation0)
	(supports instrument5 infrared2)
	(calibration_target instrument5 Star5)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 Star6)
	(calibration_target instrument5 GroundStation7)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation4)
)
(:goal (and
	(have_image Star14 infrared0)
	(have_image Phenomenon15 image3)
	(have_image Planet16 infrared0)
	(have_image Phenomenon17 infrared0)
))

)
