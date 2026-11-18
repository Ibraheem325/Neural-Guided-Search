(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	spectrograph0 - mode
	thermograph1 - mode
	GroundStation1 - direction
	Star6 - direction
	GroundStation7 - direction
	Star10 - direction
	Star12 - direction
	GroundStation15 - direction
	Star16 - direction
	Star17 - direction
	GroundStation19 - direction
	GroundStation11 - direction
	Star8 - direction
	Star13 - direction
	GroundStation4 - direction
	GroundStation14 - direction
	GroundStation5 - direction
	GroundStation0 - direction
	GroundStation18 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation9 - direction
	Phenomenon20 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation19)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
	(supports instrument1 thermograph1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 Star8)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star12)
	(supports instrument2 thermograph1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 GroundStation14)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation11)
	(supports instrument3 thermograph1)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation18)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star10)
)
(:goal (and
	(pointing satellite0 GroundStation9)
	(pointing satellite1 Star10)
	(pointing satellite2 GroundStation14)
	(have_image Phenomenon20 spectrograph0)
))

)
